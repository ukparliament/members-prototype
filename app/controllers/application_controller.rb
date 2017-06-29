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
    raise StandardError, 'Must provide valid data'
  end

  def data_check
    # check format to see if it can be rendered
    return unless DATA_FORMATS.include?(request.formats.first)

    # find corresponding data url
    @data_url = data_url
    # redirect
    if @data_url != nil
      # if so, set headers
      response.headers['Accept'] = request.formats.first
      redirect_to(@data_url.call(params).query_url) && return
    else
      raise StandardError, 'Data URL does not exist'
    end
  end
end
