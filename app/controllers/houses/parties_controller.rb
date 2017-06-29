module Houses
  class PartiesController < ApplicationController
    before_action :data_check

    def index
      @house, @parties = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call(params),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
      )

      @house = @house.first
      @parties = @parties.sort_by(:name)
    end

    def show
      @house, @party = RequestHelper.filter_response_data(
      ROUTE_MAP[:show].call(params),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
      )

      @house = @house.first
      @party = @party.first
      @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)

      raise ActionController::RoutingError, 'Invalid party id' if @party.nil?
    end

    def current
      @house, @parties = RequestHelper.filter_response_data(
      ROUTE_MAP[:current].call(params),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
      )

      @house = @house.first
      @parties = @parties.multi_direction_sort({ member_count: :desc, name: :asc })
    end


    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties },
      current: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties.current },
      show: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]) },
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
