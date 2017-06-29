module Parliaments
  class MembersController < ApplicationController
    before_action :data_check

    def index
      @parliament, @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call(params),
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @people     = @people.sort_by(:sort_name)
      @letters    = @letters.map(&:value)
    end

    def letters
      @parliament, @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:letters].call(params),
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @letters    = @letters.map(&:value)
      @people     = @people.sort_by(:sort_name)
    end

    def a_to_z
      parliament_id = params[:parliament_id]

      @parliament, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:a_to_z].call(params),
      'http://id.ukpds.org/schema/ParliamentPeriod',
      ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @letters    = @letters.map(&:value)
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members },
      a_to_z: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members },
      letters: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members(params[:letter]) }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
