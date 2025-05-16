class Devices::HardwareItemSerializer
  include JSONAPI::Serializer
  attributes :name,
             :description,
             :serial_number,
             :last_online_at,
             :firmware_version,
             :uptime,
             :receive_data,
             :aes_key

  belongs_to :hardware_model, serializer: Devices::HardwareModelSerializer
end
