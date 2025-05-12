class Devices::HardwareModel < ApplicationRecord
  has_many :hardware_items, class_name: 'Devices::HardwareItem', dependent: :destroy
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :sensor_types,
                          class_name: 'Devices::SensorType',
                          join_table: 'devices_hardware_models_sensor_types',
                          association_foreign_key: :devices_sensor_type_id,
                          foreign_key: :devices_hardware_model_id

end



