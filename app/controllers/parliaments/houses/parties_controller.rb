module Parliaments
  module Houses
    class PartiesController < ApplicationController
      before_action :data_check

      def index
        parliament_id = params[:parliament_id]
        house_id      = params[:house_id]

        @parliament, @house, @parties, @letters = RequestHelper.filter_response_data(
        parliament_request.parliaments(parliament_id).houses(house_id).parties,
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party',
        ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @house      = @house.first
        @parties    = @parties.sort_by(:name)
        @letters    = @letters.map(&:values)
      end

      def show
        parliament_id = params[:parliament_id]
        house_id      = params[:house_id]
        party_id      = params[:party_id]

        @parliament, @house, @party = RequestHelper.filter_response_data(
        parliament_request.parliaments(parliament_id).houses(house_id).parties(party_id),
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party'
        )

        fail ActionController::RoutingError, 'Not Found' if @party.empty?

        @parliament = @parliament.first
        @house      = @house.first
        @party      = @party.first
      end

      private

      ROUTE_MAP = {
        index: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses(params[:house_id]).parties },
        show: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses(params[:house_id]).parties(params[:party_id]) },
      }.freeze

      def data_url
        ROUTE_MAP[params[:action].to_sym]
      end
    end
  end
end
