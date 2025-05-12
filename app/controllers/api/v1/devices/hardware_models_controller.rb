class Api::V1::Devices::HardwareModelsController < Api::V1::BaseController
  include Jsonapi::Crud

  def resource_class
    Devices::HardwareModel
  end

  private

  def permitted_attributes
    [
      :name,
      :description,
      :sensor_type_ids => []
    ]
  end
end
