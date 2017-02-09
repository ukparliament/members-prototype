require 'vcard/vcard'
require 'parliament'

class ApplicationController < ActionController::Base
  include JSON_LD_Helper
  include FormatHelper
  include NotFoundHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'pugin/layouts/pugin'

  def index
  end

  def a_to_z
    @root_path = request.path
  end
end
