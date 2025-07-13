require_relative '../../config/environment'
require_relative '../test_helper'
require "ostruct"

class SensorDataTest < Minitest::Test
  DummyRelation = Struct.new(:records) do
    def select(*) = self
    def where(*) = self
    def order(*) = records
    def group(*) = self
    def count = records.size
    def first = records.first
    def all = records
  end

  DummySensorType = Struct.new(:scalable, :scalable_by, :general_data_method)
  DummySensor = Struct.new(:id, :sensor_type, :sensor_data_raw, :sensor_data_10s,
                          :sensor_data_1m, :sensor_data_10m, :sensor_data_1h)

  def setup
    @between = Time.at(0)..Time.at(10)
    st = DummySensorType.new(true, 'avg', 'none')
    rel = DummyRelation.new([])
    @sensor = DummySensor.new(1, st, rel.dup, rel.dup, rel.dup, rel.dup, rel.dup)
  end

  def test_capacity_with_param
    sd = SensorData.new(@sensor, @between, '10s', nil)
    assert_equal '10s', sd.capacity
  end

  def test_capacity_ranges
    assert_equal 'raw', SensorData.new(@sensor, Time.at(0)..Time.at(1000), nil, nil).capacity
    assert_equal '10s', SensorData.new(@sensor, Time.at(0)..Time.at(2000), nil, nil).capacity
    assert_equal '1m', SensorData.new(@sensor, Time.at(0)..Time.at(20000), nil, nil).capacity
    assert_equal '10m', SensorData.new(@sensor, Time.at(0)..Time.at(200000), nil, nil).capacity
    assert_equal '1h', SensorData.new(@sensor, Time.at(0)..Time.at(2000000), nil, nil).capacity
  end

  def test_scalable_by
    sd = SensorData.new(@sensor, @between, nil, 'max')
    assert_equal 'max', sd.scalable_by
    sd2 = SensorData.new(@sensor, @between, nil, nil)
    assert_equal 'avg', sd2.scalable_by
  end

  def test_select_strings
    sd = SensorData.new(@sensor, @between, nil, 'avg')
    assert_match /avgMerge/, sd.select
    sd = SensorData.new(@sensor, @between, nil, 'max')
    assert_match /maxMerge/, sd.select
    sd = SensorData.new(@sensor, @between, nil, 'min')
    assert_match /minMerge/, sd.select
    sd = SensorData.new(@sensor, @between, nil, 'sum')
    assert_match /sumMerge/, sd.select
    sd = SensorData.new(@sensor, @between, nil, 'diff')
    assert_match /minMerge/, sd.select
  end

  def test_prepare_data_diff
    items = [OpenStruct.new(max_value: 3, value: 0), OpenStruct.new(max_value: 5, value: 0)]
    sd = SensorData.new(@sensor, @between, '10s', 'diff')
    result = sd.prepare_data(items)
    assert_equal 0, result[0].value
    assert_equal 2, result[1].value
  end

  def test_timeline_capacity_paths
    sd = SensorData.new(@sensor, @between, '10s', 'avg')
    SensorData::Rollup10s.stub(:chart_data, ['10s']) do
      assert_equal ['10s'], sd.timeline
    end

    sd = SensorData.new(@sensor, @between, '1m', 'avg')
    SensorData::Rollup1m.stub(:chart_data, ['1m']) do
      assert_equal ['1m'], sd.timeline
    end
  end

  def test_timeline_non_scalable
    @sensor.sensor_type.scalable = false
    rel = DummyRelation.new([OpenStruct.new(value: 1)])
    @sensor.sensor_data_raw = rel
    sd = SensorData.new(@sensor, @between, 'raw', nil)
    assert_equal rel.records, sd.timeline
  end
end
