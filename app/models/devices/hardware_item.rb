class Devices::HardwareItem < ApplicationRecord

  belongs_to :hardware_model, class_name: 'Devices::HardwareModel', foreign_key: :hardware_model_id
  has_many :sensors, class_name: 'Devices::Sensor', foreign_key: :hardware_item_id
  has_many :sensor_data, class_name: 'SensorData::Raw', foreign_key: :hardware_item_id

  validates :serial_number, :name, presence: true, uniqueness: true
  after_create :create_sensors

  private



end
