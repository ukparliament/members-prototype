# Require gem to sanitize html to ensure safe postcode search
require 'sanitize'

class PostcodesController < ApplicationController
  before_action :data_check

  def index; end

  def show
    @postcode = PostcodeHelper.unhyphenate(Sanitize.fragment(params[:postcode], Sanitize::Config::RELAXED))

    begin
      response = PostcodeHelper.lookup(@postcode)

      @constituency, @person = response.filter('http://id.ukpds.org/schema/ConstituencyGroup', 'http://id.ukpds.org/schema/Person')
      @constituency = @constituency.first
    rescue PostcodeHelper::PostcodeError => error
      flash[:error] = error.message
      flash[:postcode] = @postcode

      redirect_to(PostcodeHelper.previous_path)
    end

    # Instance variable for single MP pages
    @single_mp = true
  end

  def lookup
    raw_postcode = params[:postcode]
    previous_controller = params[:previous_controller]
    previous_action = params[:previous_action]
    previous_path = url_for(controller: previous_controller, action: previous_action)
    PostcodeHelper.previous_path = previous_path

    if raw_postcode.gsub(/\s+/, '').empty?
      flash[:error] = I18n.t('error.postcode_invalid').capitalize

      redirect_to(PostcodeHelper.previous_path) && return
    end

    hyphenated_postcode = PostcodeHelper.hyphenate(raw_postcode)

    redirect_to postcode_path(hyphenated_postcode)
  end

  private

  ROUTE_MAP = {
    show: proc { |params| ParliamentHelper.parliament_request.constituencies.postcode_lookup(params[:postcode]) }
  }.freeze

  def data_url
    ROUTE_MAP[params[:action].to_sym]
  end
end
