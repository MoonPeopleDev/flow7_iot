class SensorData::Rollup10s < SensorData::Base
  include Chartable

  self.table_name = 'sensor_data_rollup_10s'

  INTERVAL = 10
end
