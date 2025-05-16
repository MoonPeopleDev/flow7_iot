class Devices::HardwareItem < ApplicationRecord

  belongs_to :hardware_model, class_name: 'Devices::HardwareModel', foreign_key: :hardware_model_id
  has_many :sensors, class_name: 'Devices::Sensor', foreign_key: :hardware_item_id
  has_many :sensor_data, class_name: 'SensorData::Raw', foreign_key: :hardware_item_id

  validates :serial_number, :name, presence: true, uniqueness: true
  after_create :create_sensors

  private


  def create_sensors
    hardware_model.sensor_types.each do |sensor_type|
      sensors.create(
        name: sensor_type.name,
        description: sensor_type.description,
        sensor_type_id: sensor_type.id,
        threshold_active: 3,
        threshold_idle: 2,
        threshold_shutdown: 1
      )
    end
  end

end
