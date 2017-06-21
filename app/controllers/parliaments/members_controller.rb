module Parliaments
  class MembersController < ApplicationController
    before_action :data_check

    def index
      parliament_id = params[:parliament_id]

      @parliament, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id).members,
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @people     = @people.sort_by(:sort_name)
      @letters    = @letters.map(&:value)
    end

    def letters
      parliament_id = params[:parliament_id]
      letter = params[:letter]

      @parliament, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id).members(letter),
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
      parliament_request.parliaments(parliament_id).members,
      'http://id.ukpds.org/schema/ParliamentPeriod',
      ::Grom::Node::BLANK
      )

      @parliament = @parliament.first
      @letters    = @letters.map(&:value)
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members },
      a_to_z: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members.a_z_letters },
      letters: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).members(params[:letter]) }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
