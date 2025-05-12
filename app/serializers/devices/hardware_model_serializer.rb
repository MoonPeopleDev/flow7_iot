class Devices::HardwareModelSerializer
  include JSONAPI::Serializer
  attributes :name,
             :description
  has_many :sensor_types
end
