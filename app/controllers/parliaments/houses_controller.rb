module Parliaments
  class HousesController < ApplicationController
    before_action :data_check

    def index
      parliament_id = params[:parliament_id]

      @parliament, @houses = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id).houses,
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/House'
      )

      @parliament = @parliament.first
      @houses     = @houses.sort_by(:name)
    end

    def show
      parliament_id = params[:parliament_id]
      house_id      = params[:house_id]

      @parliament, @house = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id).houses(house_id),
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/House'
      )

      raise ActionController::RoutingError, 'Not Found' if @house.empty?

      @parliament = @parliament.first
      @house      = @house.first
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses },
      show: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses(params[:house_id]) }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
