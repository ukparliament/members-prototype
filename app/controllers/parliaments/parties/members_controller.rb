module Parliaments
  module Parties
    class MembersController < ApplicationController
      before_action :data_check

      def index
        @parliament, @party, @people, @letters = RequestHelper.filter_response_data(
        ROUTE_MAP[:index].call(params),
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/Party',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @party      = @party.first
        @people     = @people.sort_by(:sort_name)
        @letters    = @letters.map(&:value)
      end

      def a_to_z
        @parliament, @party, @letters = RequestHelper.filter_response_data(
        ROUTE_MAP[:a_to_z].call(params),
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/Party',
        ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @party      = @party.first
        @letters    = @letters.map(&:value)
      end

      def letters
        @parliament, @party, @people, @letters = RequestHelper.filter_response_data(
        ROUTE_MAP[:letters].call(params),
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/Party',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @party      = @party.first
        @people     = @people.sort_by(:sort_name)
        @letters    = @letters.map(&:value)
      end

      private

      ROUTE_MAP = {
        index: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).parties(params[:party_id]).members },
        a_to_z: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).parties(params[:party_id]).members },
        letters: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).parties(params[:party_id]).members(params[:letter]) }
      }.freeze

      def data_url
        ROUTE_MAP[params[:action].to_sym]
      end
    end
  end
end
