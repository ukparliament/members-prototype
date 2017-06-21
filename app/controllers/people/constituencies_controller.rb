module People
  class ConstituenciesController < ApplicationController
    before_action :data_check

    def index
      person_id = params[:person_id]

      @person, @seat_incumbencies = RequestHelper.filter_response_data(
      parliament_request.people(person_id).constituencies,
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/SeatIncumbency'
      )

      @person = @person.first
      @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)
    end

    def current
      person_id = params[:person_id]

      @person, @constituency = RequestHelper.filter_response_data(
      parliament_request.people(person_id).constituencies.current,
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/ConstituencyGroup'
      )

      @person = @person.first
      @constituency = @constituency.first
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.people(params[:person_id]).constituencies },
      current: proc { |params| ParliamentHelper.parliament_request.people(params[:person_id]).constituencies.current }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
