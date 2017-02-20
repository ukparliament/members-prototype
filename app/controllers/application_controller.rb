require 'vcard/vcard'
require 'parliament'

class ApplicationController < ActionController::Base
  include JSONLDHelper
  include FormatHelper
  include NotFoundHelper
  include VCardHelper
  include Parliament

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'pugin/layouts/pugin'

  def a_to_z
    @root_path = request.path
  end

  rescue_from Parliament::NoContentError do |error|
    raise ActionController::RoutingError, error.message
  end
end
