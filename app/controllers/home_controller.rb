class HomeController < ApplicationController
  before_action :disable_top_navigation, :disable_status_banner, :data_check

  def index; end

  def mps
    @parliaments, @parties, @speaker = RequestHelper.filter_response_data(
      ROUTE_MAP[:mps].call,
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )

    @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
  end

  private

  ROUTE_MAP = {
    mps: proc { ParliamentHelper.parliament_request.people.mps }
  }.freeze

  def data_url
    ROUTE_MAP[params[:action].to_sym]
  end
end
