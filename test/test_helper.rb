require 'minitest/autorun'
require 'active_support/all'
require 'action_controller/railtie'
require 'active_record'

# Minimal ApplicationController setup for tests
module Api; module V1; end; end
class ApplicationController < ActionController::Base
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception
end

require_relative '../app/controllers/api/v1/base_controller'
require_relative '../app/lib/sensor_data'
