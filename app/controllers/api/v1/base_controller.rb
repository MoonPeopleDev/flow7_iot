class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found(exception)
    render json: {
      errors: [
        {
          status: '404',
          title: 'Record not found',
          detail: exception.message
        }
      ]
    }, status: :not_found
  end
end
