class SensorData::Rollup1h < SensorData::Base
  include Chartable

  self.table_name = 'sensor_data_rollup_1h'

  INTERVAL = 3600
end
