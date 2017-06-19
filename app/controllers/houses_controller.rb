class HousesController < ApplicationController
  before_action :data_check
  
  def index
    @houses = parliament_request.houses.get.sort_by(:name)
  end

  def show
    house_id = params[:house_id]

    @house = RequestHelper.filter_response_data(
      parliament_request.houses(house_id),
      'http://id.ukpds.org/schema/House'
    ).first
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @house = parliament_request.houses.lookup(source, id).get.first

    redirect_to house_path(@house.graph_id)
  end

  def lookup_by_letters
    letters = params[:letters]

    data = parliament_request.houses.partial(letters).get

    if data.size == 1
      redirect_to house_path(data.first.graph_id)
    else
      redirect_to houses_path
    end
  end
end
