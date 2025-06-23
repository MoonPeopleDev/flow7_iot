class Api::V1::Devices::SensorsController < Api::V1::BaseController
  include Jsonapi::Crud

  def resource_class
    Devices::Sensor
  end

  def create

  end

  def destroy

  end

  private

  def permitted_attributes
    [
      :name,
      :description,
      :sensor_type_id,
      :hardware_item_id,
      :threshold_active,
      :threshold_idle,
      :threshold_shutdown,
      :cycle_threshold,
      :algo,
      :value_factor,
      :power_factor
    ]
  end
end
