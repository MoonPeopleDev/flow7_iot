class Api::V1::Devices::SensorTypesController < Api::V1::BaseController
  include Jsonapi::Crud

  def resource_class
    Devices::SensorType
  end

  private

  def permitted_attributes
    [
      :name,
      :description,
      :data_key_name,
      :scalable,
      :scalable_by,
      :general_data_method,
      :chart_type
    ]
  end

  def enum_meta
    {
      enums: {
        scalable_by: Devices::SensorType.scalable_bies.keys,
        general_data_method: Devices::SensorType.general_data_methods.keys,
        chart_type: Devices::SensorType.chart_types.keys
      }
    }
  end
end
