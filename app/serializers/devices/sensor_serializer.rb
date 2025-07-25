class Devices::SensorSerializer
  include JSONAPI::Serializer
  attributes :name,
             :description,
             #:threshold_active,
             :threshold_idle,
             :threshold_shutdown,
             :cycle_threshold,
             :algo,
             :value_factor,
             :power_factor

  belongs_to :sensor_type
  belongs_to :hardware_item
end
