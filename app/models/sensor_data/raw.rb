class SensorData::Raw < SensorData::Base
  self.table_name = 'sensor_data_raw'

  def insert(data)
    pp data
  end

end
