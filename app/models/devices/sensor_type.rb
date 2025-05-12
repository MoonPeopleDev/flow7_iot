class Devices::SensorType < ApplicationRecord
  has_many :sensors, class_name: 'Devices::Sensor'

  has_and_belongs_to_many :hardware_models,
                          class_name: 'Devices::HardwareModel',
                          join_table: 'devices_hardware_models_sensor_types',
                          dependent: :destroy,
                          association_foreign_key: :devices_hardware_model_id,
                          foreign_key: :devices_sensor_type_id


  validates :data_key_name, :name, presence: true, uniqueness: true
  enum :scalable_by, { avg: 0, max: 1, min: 2, sum: 3 }, suffix: true
  enum :general_data_method, { none: 0, min_max_average: 1, work_idle_times: 2, rfid_hold_times: 3, rfid_touch_times: 4, sum: 5 }, suffix: true
  enum :chart_type, { super_chart: 0, mega_chart: 1, milk_chart: 2, i_chart: 3, ac_chart: 4 }

  def self.rfid_hold
    Devices::SensorType.find_by!(data_key_name: 'rfid_hold')
  end
end


