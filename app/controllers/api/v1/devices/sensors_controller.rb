class Api::V1::Devices::SensorsController < Api::V1::BaseController
  include Jsonapi::Crud

  before_action :set_resource, only: [:data]

  def resource_class
    Devices::Sensor
  end

  def create

  end

  def destroy

  end

  def data
    between = parse_times
    data = SensorData.new(@resource, between, params[:capacity], params[:scalable_by])
    render json: Devices::SensorDataSerializer.new(@resource, params: { data: data })
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
