class Devices::SensorTypeSerializer
  include JSONAPI::Serializer
  attributes :name,
             :description,
             :data_key_name,
             :scalable,
             :scalable_by,
             :general_data_method,
             :chart_type
end
