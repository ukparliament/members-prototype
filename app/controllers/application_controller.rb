require 'vcard/vcard'
require 'parliament'
require 'houses_helper'
require 'request_helper'
require 'parliament_helper'
require 'format_helper'
require 'pugin/helpers/controller_helpers'

# Base class for all other controllers
class ApplicationController < ActionController::Base
  include VCardHelper
  include Parliament
  include HousesHelper
  include RequestHelper
  include ParliamentHelper
  include ResourceHelper
  include FormatHelper
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

  def data_url
    self.class::ROUTE_MAP[params[:action].to_sym] || raise(StandardError, "You must provide a ROUTE_MAP proc for #{params[:controller]}##{params[:action]}")
  end

  def build_request
    @request = data_url.call(params)
  end

  def data_check
    # Check format to see if it is available from the data API
    return if !DATA_FORMATS.include?(request.formats.first) || (params[:controller] == 'constituencies' && params[:action] == 'map')

    # Find the current controller/action's API url
    @data_url = data_url

    # Catch potential nil values
    raise StandardError, 'Data URL does not exist' if @data_url.nil?

    response.headers['Accept'] = request.formats.first
    redirect_to(@data_url.call(params).query_url) && return
  end
end
