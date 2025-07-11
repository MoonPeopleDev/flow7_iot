require_relative '../../../test_helper'
require 'active_support/testing/time_helpers'

class BaseControllerTest < Minitest::Test
  include ActiveSupport::Testing::TimeHelpers

  class DummyController < Api::V1::BaseController
    attr_accessor :test_params

    private

    def params
      ActionController::Parameters.new(@test_params || {})
    end
  end

  def setup
    Time.zone = 'UTC'
    @controller = DummyController.new
  end

  def test_parse_times_success
    @controller.test_params = { from: '2024-01-01T00:00:00Z', to: '2024-01-02T00:00:00Z' }
    range = @controller.send(:parse_times)
    assert_equal Time.zone.parse('2024-01-01T00:00:00Z'), range.first
    assert_equal Time.zone.parse('2024-01-02T00:00:00Z'), range.last
  end

  def test_parse_times_missing_param
    @controller.test_params = { from: '2024-01-01T00:00:00Z' }
    assert_raises(ActionController::ParameterMissing) { @controller.send(:parse_times) }
  end

  def test_parse_day_times_without_params
    @controller.test_params = { from: '2024-01-01T00:00:00Z', to: '2024-01-02T00:00:00Z' }
    assert_nil @controller.send(:parse_day_times)
  end

  def test_parse_day_times_with_valid_params
    @controller.test_params = {
      from: '2024-01-01T00:00:00Z',
      to: '2024-01-03T00:00:00Z',
      day_time_from: '06:00',
      day_time_to: '18:00'
    }
    range = @controller.send(:parse_day_times)
    assert_equal Time.zone.parse('2024-01-01 06:00'), range.first
    expected = Time.zone.parse('2024-01-03 18:00') + 0.999999
    assert_in_delta expected.to_f, range.last.to_f, 0.000001
  end

  def test_parse_day_times_cross_midnight
    travel_to Time.zone.parse('2024-01-02 01:00') do
      @controller.test_params = {
        from: '2024-01-01T00:00:00Z',
        to: '2024-01-03T00:00:00Z',
        day_time_from: '23:00',
        day_time_to: '05:00'
      }
      range = @controller.send(:parse_day_times)
      assert_equal Time.zone.parse('2024-01-01 23:00'), range.first
      expected = Time.zone.parse('2024-01-03 05:00') + 0.999999
      assert_in_delta expected.to_f, range.last.to_f, 0.000001
    end
  end
end
