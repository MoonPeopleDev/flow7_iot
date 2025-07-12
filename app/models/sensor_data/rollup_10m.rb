class SensorData::Rollup10m < SensorData::Base
  include Chartable

  self.table_name = 'sensor_data_rollup_10m'

  INTERVAL = 600
end
