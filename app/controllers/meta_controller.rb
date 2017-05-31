class MetaController < ApplicationController
  before_action :disable_top_navigation

  def index
    @meta_routes = []
    Rails.application.routes.routes.each do |route|
      path = route.path.spec.to_s

      next unless path.starts_with?('/meta/')

      path = path.sub(/\(.:format\)/, '')
      translation = path.split('/').last
      @meta_routes << { url: path, translation: translation }
    end

    render 'index'
  end

  def cookie_policy
    render 'cookie_policy'
  end
end
