module Parliaments
  module Houses
    class MembersController < ApplicationController
      before_action :data_check

      def index
        @parliament, @house, @people, @letters = RequestHelper.filter_response_data(
        ROUTE_MAP[:index].call(params),
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @house      = @house.first
        @people     = @people.sort_by(:sort_name)
        @letters    = @letters.map(&:value)
      end

      def a_to_z
        @parliament, @house, @letters = RequestHelper.filter_response_data(
        ROUTE_MAP[:a_to_z].call(params),
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/House',
        ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @house      = @house.first
        @letters    = @letters.map(&:value)
      end

      def letters
        @parliament, @house, @people, @letters = RequestHelper.filter_response_data(
        ROUTE_MAP[:letters].call(params),
        'http://id.ukpds.org/schema/ParliamentPeriod',
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )

        @parliament = @parliament.first
        @house      = @house.first
        @people     = @people.sort_by(:sort_name)
        @letters    = @letters.map(&:value)
      end

      private

      ROUTE_MAP = {
        index: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses(params[:house_id]).members },
        a_to_z: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses(params[:house_id]).members },
        letters: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).houses(params[:house_id]).members(params[:letter]) },
      }.freeze

      def data_url
        ROUTE_MAP[params[:action].to_sym]
      end
    end
  end
end
