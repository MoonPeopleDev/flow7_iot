class Api::V1::Devices::HardwareItemsController < Api::V1::BaseController
  include Jsonapi::Crud

  def resource_class
    Devices::HardwareItem
  end

  def reset_crypto
    set_resource
    @resource.aes_key = nil
    @resource.save!
  end

  private

  def permitted_attributes
    [
      :name,
      :description,
      :hardware_model_id,
      :serial_number
    ]
  end
end
