class HousesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    # index:             proc { ParliamentHelper.parliament_request.houses },
    index:             proc { ParliamentHelper.parliament_request.house_index },
    show:              proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]) },
    lookup:            proc { |params| ParliamentHelper.parliament_request.houses.lookup(params[:source], params[:id]) },
    lookup_by_letters: proc { |params| ParliamentHelper.parliament_request.houses.partial(params[:letters]) }
  }.freeze

  def index
    @houses = @request.get.sort_by(:name)
  end

  def show
    @house = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/House'
    ).first
  end

  def lookup
    @house = @request.get.first

    redirect_to house_path(@house.graph_id)
  end

  def lookup_by_letters
    data = @request.get

    if data.size == 1
      redirect_to house_path(data.first.graph_id)
    else
      redirect_to houses_path
    end
  end
end
