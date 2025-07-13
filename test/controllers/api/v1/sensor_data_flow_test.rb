require_relative '../../../../config/environment'
require_relative '../../../test_helper'
require 'base64'
require 'openssl'
require 'securerandom'

class SensorDataFlowTest < ActionDispatch::IntegrationTest
  VALID_SCALABLES = SensorData::VALID_SCALABLES
  VALID_CAPACITIES = SensorData::VALID_CAPACITIES

  def setup
    Time.zone = 'UTC'
    @sensor_type = Devices::SensorType.create!(
      name: 'Current',
      data_key_name: 'i',
      description: 'I',
      scalable: true,
      scalable_by: :avg,
      general_data_method: :none,
      chart_type: 0
    )
    @hardware_model = Devices::HardwareModel.create!(name: 'Model', description: '', sensor_types: [@sensor_type])
    Devices::HardwareItem.skip_callback(:create, :after, :create_sensors)
    @device = Devices::HardwareItem.create!(name: 'Device', description: '', hardware_model: @hardware_model, serial_number: 'sn-1', receive_data: true)
    Devices::HardwareItem.set_callback(:create, :after, :create_sensors)
    @sensor = Devices::Sensor.create!(name: 'S', description: '', sensor_type: @sensor_type, hardware_item: @device, threshold_idle: 0, threshold_shutdown: 0, cycle_threshold: 0, algo: 0)
    @now = Time.zone.parse('2025-07-13 16:55:00')
    @key = SecureRandom.random_bytes(16)
    @device.update!(aes_key: @key)
  end

  def teardown
    SensorData::Raw.connection.execute('TRUNCATE TABLE sensor_data_raw')
    SensorData::Rollup10s.connection.execute('TRUNCATE TABLE sensor_data_rollup_10s')
    SensorData::Rollup1m.connection.execute('TRUNCATE TABLE sensor_data_rollup_1m')
    SensorData::Rollup10m.connection.execute('TRUNCATE TABLE sensor_data_rollup_10m')
    SensorData::Rollup1h.connection.execute('TRUNCATE TABLE sensor_data_rollup_1h')
    Devices::Sensor.delete_all
    Devices::HardwareItem.delete_all
    Devices::HardwareModel.delete_all
    Devices::SensorType.delete_all
  end

  def send_payload(values)
    items = values.each_with_index.map { |v, i| { ts: ((@now + i.seconds).to_i * 1000), i: v } }
    payload = { firmware: 'v1', model: 'Model', uptime: 1, ts: (@now.to_i * 1000), data: items }
    plain = payload.to_json
    plain_padded = plain.ljust((16 - plain.bytesize % 16) % 16 + plain.bytesize, "\0")
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = @key
    iv = SecureRandom.random_bytes(16)
    cipher.iv = iv
    cipher.padding = 0
    encrypted = cipher.update(plain_padded) + cipher.final
    headers = {
      'X-Device-ID' => @device.serial_number,
      'X-Nonce' => Base64.strict_encode64(iv),
      'CONTENT_TYPE' => 'application/octet-stream'
    }
    post api_v1_sensor_data_receive_path, headers: headers, params: encrypted
    assert_response :success
  end

  def rollup_values(values, capacity, scalable)
    groups = case capacity
             when 'raw'
               values.map { |v| [v] }
             when '10s'
               values.each_slice(10).to_a
             when '1m'
               [values]
             else
               []
             end
    result = groups.map do |g|
      g_no_zero = g.reject(&:zero?)
      case scalable
      when 'avg'
        g.sum.to_f / g.size
      when 'avg_no_zeros'
        g_no_zero.empty? ? 0 : g_no_zero.sum.to_f / g_no_zero.size
      when 'max'
        g.max
      when 'min'
        g.min
      when 'sum'
        g.sum
      when 'diff'
        capacity == 'raw' ? g.first : g.max - g.min
      end
    end
    if scalable == 'diff' && capacity != 'raw'
      prev = nil
      result = groups.map do |g|
        diff = prev.nil? ? g.max - g.min : g.max - prev
        prev = g.max
        diff
      end
    end
    result
  end

  def test_full_clickhouse_flow
    values = (1..30).to_a
    send_payload(values)
    assert_equal 30, SensorData::Raw.count
    from = @now.iso8601
    to = (@now + 29.seconds).iso8601
    VALID_CAPACITIES.each do |cap|
      VALID_SCALABLES.each do |scal|
        get data_api_v1_devices_sensor_path(@sensor.id), params: { from: from, to: to, capacity: cap, scalable_by: scal }
        assert_response :success
        body = JSON.parse(response.body)
        data = body['data']['attributes']['data']
        expected = rollup_values(values, cap, scal)
        timeline_values = data[1..-2].map { |d| d['v'] }
        assert_equal expected.length + 2, data.length
        assert_equal expected.map { |v| v.is_a?(Float) ? v.round(5) : v }, timeline_values.map { |v| v.is_a?(Float) ? v.round(5) : v }
      end
    end
  end
end
