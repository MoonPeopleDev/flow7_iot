module Jsonapi::Crud
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: [:show, :update, :destroy]
  end

  def index
    page_number = params.dig(:page, :number) || 1
    page_size = params.dig(:page, :size) || 25

    resources = resource_class.page(page_number).per(page_size)
    render json: serializer.new(resources, meta: pagination_meta(resources))
  end

  def show
    if respond_to?(:enum_meta, true)
      render json: serializer.new(@resource, meta: enum_meta)
    else
      render json: serializer.new(@resource)
    end
  end

  def create
    pp resource_params
    @resource = resource_class.new(resource_params)
    if @resource.save
      render json: serializer.new(@resource), status: :created
    else
      render json: { errors: format_errors(@resource) }, status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(resource_params)
      render json: serializer.new(@resource)
    else
      render json: { errors: format_errors(@resource) }, status: :unprocessable_entity
    end
  end

  def destroy
    @resource.destroy
    head :no_content
  end

  private

  def pagination_meta(collection)
    {
      pagination: {
        total: collection.total_count,
        count: collection.size,
        per_page: collection.limit_value,
        current_page: collection.current_page,
        total_pages: collection.total_pages
      }
    }
  end

  def set_resource
    @resource = resource_class.find(params[:id])
  end

  def serializer
    "#{resource_class}Serializer".constantize
  end

  def resource_params
    params.require(:data).permit(permitted_attributes)
  end

  def resource_name
    controller_name.singularize
  end

  def permitted_attributes
    raise NotImplementedError, 'You must implement permitted_attributes in your controller'
  end

  def format_errors(resource)
    resource.errors.map do |field|
      {
        source: { pointer: "/data/attributes/#{field.attribute}" },
        detail: field.message
      }
    end
  end
end
