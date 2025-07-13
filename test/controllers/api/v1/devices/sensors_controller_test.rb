require_relative "../../../../../config/environment"
require_relative '../../../../test_helper'
require 'base64'
require 'openssl'
require 'securerandom'
require 'ostruct'

class SensorsControllerTest < ActionDispatch::IntegrationTest
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
    @device = Devices::HardwareItem.create!(name: 'Device', description: '', hardware_model: @hardware_model, serial_number: 'sn-1')
    Devices::HardwareItem.set_callback(:create, :after, :create_sensors)
    @sensor = Devices::Sensor.create!(name: 'S', description: '', sensor_type: @sensor_type, hardware_item: @device, threshold_idle: 0, threshold_shutdown: 0, cycle_threshold: 0, algo: 0)
    @now = Time.zone.parse('2025-07-13 16:55:00')
    @key = SecureRandom.random_bytes(16)
    @device.update!(aes_key: @key)
  end

  def teardown
    SensorData::Raw.connection.execute("TRUNCATE TABLE sensor_data_raw")
    SensorData::Raw.delete_all
    Devices::Sensor.delete_all
    Devices::HardwareItem.delete_all
    Devices::HardwareModel.delete_all
    Devices::SensorType.delete_all
  end

  def send_payload(value)
    payload = { firmware: 'v1', model: 'Model', uptime: 1, ts: (@now.to_i * 1000), data: [{ ts: (@now.to_i * 1000), i: value }] }
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

  def stub_rollups(value)
    row = OpenStruct.new(at: @now, value: value, min_value: value, max_value: value)
    SensorData::Rollup10s.stub(:chart_data, [row]) do
      SensorData::Rollup1m.stub(:chart_data, [row]) do
        SensorData::Rollup10m.stub(:chart_data, [row]) do
          SensorData::Rollup1h.stub(:chart_data, [row]) do
            yield
          end
        end
      end
    end
  end

  def test_receive_and_request_data_for_all_options
    send_payload(5)
    from = (@now - 1.second).iso8601
    to = (@now + 1.second).iso8601

    stub_rollups(5) do
      VALID_CAPACITIES.each do |cap|
        VALID_SCALABLES.each do |scal|
          get data_api_v1_devices_sensor_path(@sensor.id), params: { from: from, to: to, capacity: cap, scalable_by: scal }
          assert_response :success
          body = JSON.parse(response.body)
          data = body['data']['attributes']['data']
          assert_equal 3, data.length
          assert_equal 5, data[1]['v']
        end
      end
    end
  end
end
