class HousesController < ApplicationController
  before_action :data_check

  def index
    @houses = ROUTE_MAP[:index].call.get.sort_by(:name)
  end

  def show
    @house = RequestHelper.filter_response_data(
      ROUTE_MAP[:show].call(params),
      'http://id.ukpds.org/schema/House'
    ).first
  end

  def lookup
    @house = ROUTE_MAP[:lookup].call(params).get.first

    redirect_to house_path(@house.graph_id)
  end

  def lookup_by_letters
    data = ROUTE_MAP[:lookup_by_letters].call(params).get

    if data.size == 1
      redirect_to house_path(data.first.graph_id)
    else
      redirect_to houses_path
    end
  end

  private

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.houses },
    show: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]) },
    lookup: proc { |params| ParliamentHelper.parliament_request.houses.lookup(params[:source], params[:id]) },
    lookup_by_letters: proc { |params| ParliamentHelper.parliament_request.houses.partial(params[:letters]) }
  }.freeze

  def data_url
    ROUTE_MAP[params[:action].to_sym]
  end
end
