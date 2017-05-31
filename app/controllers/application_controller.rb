require 'vcard/vcard'
require 'parliament'
require 'houses_helper'
require 'request_helper'
require 'parliament_helper'
require 'pugin/helpers/controller_helpers'

# Base class for all other controllers
class ApplicationController < ActionController::Base
  include VCardHelper
  include Parliament
  include HousesHelper
  include RequestHelper
  include ParliamentHelper

  include Pugin::Helpers::ControllerHelpers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'pugin/layouts/pugin'

  # Controller helper methods available from Pugin::Helpers::ControllerHelpers
  #
  # Used to turn Pugin Features on and off at a controller level
  before_action :reset_bandiera_features, :enable_top_navigation, :enable_status_banner

  # Rescues from a Parliament::ClientError and raises an ActionController::RoutingError
  rescue_from Parliament::ClientError do |error|
    raise ActionController::RoutingError, error.message
  end

  # Rescues from a Parliament::NoContentResponseError and raises an ActionController::RoutingError
  rescue_from Parliament::NoContentResponseError do |error|
    raise ActionController::RoutingError, error.message
  end
end
