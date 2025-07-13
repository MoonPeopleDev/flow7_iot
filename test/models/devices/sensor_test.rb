require_relative '../../../config/environment'
require_relative '../../test_helper'

class DevicesSensorTest < Minitest::Test
  def build_sensor
    model = Devices::HardwareModel.new(name: 'Model')
    hardware = Devices::HardwareItem.new(name: 'Item', serial_number: 'sn', hardware_model: model)
    def hardware.online?
      @online
    end
    hardware
  end

  def build_sensor_type
    Devices::SensorType.new(name: 'Type', data_key_name: 'key', scalable: true, scalable_by: :avg, general_data_method: :none, chart_type: 0)
  end

  def test_online_methods
    hardware = build_sensor
    hardware.instance_variable_set(:@online, true)
    sensor = Devices::Sensor.new(hardware_item: hardware)
    assert sensor.online?
    assert sensor.online
    hardware.instance_variable_set(:@online, false)
    refute sensor.online?
    refute sensor.online
  end

  def test_data_key_name
    sensor = Devices::Sensor.new
    sensor.sensor_type = build_sensor_type
    assert_equal 'key', sensor.data_key_name
    sensor.sensor_type = nil
    assert_nil sensor.data_key_name
  end

  def test_calculate_value_factor_without_formula
    sensor = Devices::Sensor.new(value_factor: nil)
    assert_equal 5, sensor.calculate_value_factor(5)
    assert_equal 0, sensor.calculate_value_factor(-3)
    assert_raises(ArgumentError) { sensor.calculate_value_factor('a') }
  end

  def test_calculate_value_factor_with_formula
    sensor = Devices::Sensor.new(value_factor: 'V * 2')
    assert_equal 6, sensor.calculate_value_factor(3)
    assert_equal 0, sensor.calculate_value_factor(-3)
  end

  def test_calculate_power_factor
    sensor = Devices::Sensor.new(power_factor: 'V*0.5')
    assert_equal 5, sensor.calculate_power_factor(9)
  end

  def test_calculate_power_factor_no_formula_or_non_numeric
    sensor = Devices::Sensor.new(power_factor: nil)
    assert_equal 0, sensor.calculate_power_factor(5)
    sensor.power_factor = 'V*2'
    assert_equal 0, sensor.calculate_power_factor('a')
  end
end
