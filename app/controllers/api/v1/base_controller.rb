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

  def parse_day_times
    from = nil
    to = nil
    from_now = nil
    to_now = nil
    now = Time.zone.now

    if params[:day_time_from].present?
      date = parse_times.first
      from_base = Time.zone.parse(params[:day_time_from])
      from = from_base.change(year: date.year, month: date.month, day: date.day)
      from_now = from_base.change(year: now.year, month: now.month, day: now.day)
    end

    if params[:day_time_to].present?
      date = parse_times.last
      to_base = Time.zone.parse(params[:day_time_to]) + 0.999999
      to = to_base.change(year: date.year, month: date.month, day: date.day)
      to_now = to.change(year: now.year, month: now.month, day: now.day)
    end
    return if !from && !to
    raise ActionController::ParameterMissing.new('day_time_from or day_time_to') if !from || !to
    if from_now > to_now
      to = to + 1.day
      if to > Time.zone.now
        to = to - 1.day
      end
    end
    from..to
  end

  def parse_times
    from = params[:from].present? ? Time.zone.parse(params[:from]) : nil
    to = params[:to].present? ? Time.zone.parse(params[:to]) : nil
    raise ActionController::ParameterMissing.new('from and to') if from.nil? || to.nil?
    from..to
  end
end
