module Parties
  class MembersController < ApplicationController
    before_action :data_check

    def index
      @party, @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call(params),
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current
      @party, @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:current].call(params),
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def letters
      @party, @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:letters].call(params),
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current_letters
      @party, @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:current_letters].call(params),
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @party = @party.first
      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def a_to_z
      @party_id = params[:party_id]
      @letters = RequestHelper.process_available_letters(ROUTE_MAP[:a_to_z].call(params))
    end

    def a_to_z_current
      @party_id = params[:party_id]
      @letters = RequestHelper.process_available_letters(ROUTE_MAP[:a_to_z_current].call(params))
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.parties(params[:party_id]).members },
      current: proc { |params| ParliamentHelper.parliament_request.parties(params[:party_id]).members.current },
      letters: proc { |params| ParliamentHelper.parliament_request.parties(params[:party_id]).members(params[:letter]) },
      current_letters: proc { |params| ParliamentHelper.parliament_request.parties(params[:party_id]).members.current(params[:letter]) },
      a_to_z: proc { |params| ParliamentHelper.parliament_request.parties(params[:party_id]).members.a_z_letters },
      a_to_z_current: proc { |params| ParliamentHelper.parliament_request.parties(params[:party_id]).members.current.a_z_letters }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
