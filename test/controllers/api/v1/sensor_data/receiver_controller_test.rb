require_relative "../../../../../config/environment"
require_relative '../../../../test_helper'
require 'base64'
require 'openssl'
require 'securerandom'

class ReceiverControllerTest < ActionDispatch::IntegrationTest
  def setup
    @sensor_type = Devices::SensorType.create!(name: 'Current', data_key_name: 'i',
                                              description: 'I', scalable: false,
                                              scalable_by: 0, general_data_method: 0, chart_type: 0)
    @hardware_model = Devices::HardwareModel.create!(name: 'Model', description: '', sensor_types: [@sensor_type])
    Devices::HardwareItem.skip_callback(:create, :after, :create_sensors)
    @device = Devices::HardwareItem.create!(name: 'Device', description: '',
                                            hardware_model: @hardware_model,
                                            serial_number: 'sn-1')
    Devices::HardwareItem.set_callback(:create, :after, :create_sensors)
    @sensor = Devices::Sensor.create!(name: 'S', description: '', sensor_type: @sensor_type,
                                      hardware_item: @device, threshold_idle: 0,
                                      threshold_shutdown: 0, cycle_threshold: 0, algo: 0)
  end

  def teardown
    SensorData::Raw.connection.execute("TRUNCATE TABLE sensor_data_raw")
    SensorData::Raw.delete_all
    Devices::Sensor.delete_all
    Devices::HardwareItem.delete_all
    Devices::HardwareModel.delete_all
    Devices::SensorType.delete_all
  end

  def test_device_initialization_returns_key
    post api_v1_sensor_data_receive_path, headers: { 'X-Device-ID' => @device.serial_number }, as: :text
    assert_response :success
    assert_match /^K:[A-Za-z0-9+\/]+=*$/, response.body
    assert_not_nil @device.reload.aes_key
  end

  def test_repeat_initialization_fails
    key = SecureRandom.random_bytes(16)
    @device.update!(aes_key: key)

    post api_v1_sensor_data_receive_path, headers: { 'X-Device-ID' => @device.serial_number }, as: :text

    assert_response :bad_request
    assert_equal 'Nonce not found', response.body
    assert_equal key, @device.reload.aes_key
  end

  def test_encrypted_payload_is_saved
    key = SecureRandom.random_bytes(16)
    @device.update!(aes_key: key)
    payload = { firmware: 'v1', model: 'Model', uptime: 1,
               ts: (Time.now.to_i*1000), data: [{ ts: (Time.now.to_i*1000), i: 5 }] }
    plain = payload.to_json
    plain_padded = plain.ljust((16 - plain.bytesize % 16) % 16 + plain.bytesize, "\0")
    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.key = key
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
    assert_equal({ 'result' => 'ok' }, JSON.parse(response.body))
    assert_equal 1, SensorData::Raw.count
    rec = SensorData::Raw.first
    assert_equal @device.id, rec.device_id
    assert_equal @sensor.id, rec.sensor_id
    assert_equal 5, rec.raw_sensor_value
  end
end
