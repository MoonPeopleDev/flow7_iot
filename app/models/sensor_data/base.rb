class SensorData::Base < ApplicationRecord
  self.abstract_class = true
  connects_to database: { writing: :clickhouse, reading: :clickhouse }
end
