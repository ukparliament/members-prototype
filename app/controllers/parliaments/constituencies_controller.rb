module Parliaments
  class ConstituenciesController < ApplicationController
    before_action :data_check

    def index
      parliament_id = params[:parliament_id]

      @parliament, @constituencies, @letters = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id).constituencies,
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
      )

      @parliament     = @parliament.first
      @constituencies = @constituencies.sort_by(:name)
      @letters        = @letters.map(&:value)
    end

    def a_to_z
      parliament_id = params[:parliament_id]

      @parliament, @constituencies, @letters = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id).constituencies,
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
      )

      @parliament     = @parliament.first
      @constituencies = @constituencies.sort_by(:name)
      @letters        = @letters.map(&:value)
    end

    def letters
      parliament_id = params[:parliament_id]
      letter        = params[:letter]

      @parliament, @constituencies, @letters = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id).constituencies(letter),
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
      )

      @parliament     = @parliament.first
      @constituencies = @constituencies.sort_by(:name)
      @letters        = @letters.map(&:value)
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).constituencies },
      a_to_z: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).constituencies.a_z_letters },
      letters: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).constituencies(params[:letter]) }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
