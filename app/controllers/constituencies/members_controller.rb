module Constituencies
  class MembersController < ApplicationController
    before_action :data_check

    def index
      @constituency, @seat_incumbencies = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call(params),
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
      )

      @constituency = @constituency.first
      @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)
      @current_incumbency = @seat_incumbencies.shift if !@seat_incumbencies.empty? && @seat_incumbencies.first.current?
    end

    # Renders a constituency and the current incumbent given a constituency id.
    # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
    # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup'.
    # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/SeatIncumbency'.

    def current
      @constituency, @seat_incumbency = RequestHelper.filter_response_data(
      ROUTE_MAP[:current].call(params),
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
      )

      @constituency = @constituency.first
      @seat_incumbency = @seat_incumbency.first
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.constituencies(params[:constituency_id]).members },
      current: proc { |params| ParliamentHelper.parliament_request.constituencies(params[:constituency_id]).members.current }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
