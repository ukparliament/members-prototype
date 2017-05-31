require 'vcard/vcard'
require 'parliament'
require 'houses_helper'
require 'request_helper'
require 'parliament_helper'

# Base class for all other controllers
class ApplicationController < ActionController::Base
  include VCardHelper
  include Parliament
  include HousesHelper
  include RequestHelper
  include ParliamentHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'pugin/layouts/pugin'

  before_action :enable_navigation_main

  private

  def enable_navigation_main
    @enable_navigation_main = true
  end

  def disable_navigation_main
    @enable_navigation_main = false
  end

  # Rescues from a Parliament::ClientError and raises an ActionController::RoutingError
  rescue_from Parliament::ClientError do |error|
    raise ActionController::RoutingError, error.message
  end

  # Rescues from a Parliament::NoContentResponseError and raises an ActionController::RoutingError
  rescue_from Parliament::NoContentResponseError do |error|
    raise ActionController::RoutingError, error.message
  end
end
