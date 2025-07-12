class SensorData::Rollup1m < SensorData::Base
  include Chartable

  self.table_name = 'sensor_data_rollup_1m'

  INTERVAL = 60
end
