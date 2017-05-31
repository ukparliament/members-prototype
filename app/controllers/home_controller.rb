class HomeController < ApplicationController
  before_action :disable_top_navigation, :disable_status_banner

  def index; end
end
