require 'vcard/vcard'
require 'parliament'
require 'houses_id_helper'

class ApplicationController < ActionController::Base
  include VCardHelper
  include Parliament
  include HouseIdHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout 'pugin/layouts/pugin'

  def a_to_z
    @root_path = request.path
  end
  
  rescue_from StandardError do |exception|
    case
      when exception.to_s =~ /NoContentError/
        render :template => 'errors/no_content'

      when exception.to_s =~ /InternalServerError|RuntimeError/
        render :template => 'errors/internal_server_error'

      when exception.to_s =~ /NotFoundError/
        render :template => 'errors/not_found'
      else
         raise "#{exception}"
     end
    end

