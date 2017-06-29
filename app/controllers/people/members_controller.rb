module People
  class MembersController < ApplicationController
    before_action :data_check

    def index
      @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call,
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current
      @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:current].call,
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def letters
      @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:letters].call(params),
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def current_letters
      @people, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:current_letters].call(params),
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
      )

      @people = @people.sort_by(:sort_name)
      @letters = @letters.map(&:value)
    end

    def a_to_z
      @letters = RequestHelper.process_available_letters(ROUTE_MAP[:a_to_z].call)
    end

    def a_to_z_current
      @letters = RequestHelper.process_available_letters(ROUTE_MAP[:a_to_z_current].call)
    end

    private

    ROUTE_MAP = {
      index: proc { ParliamentHelper.parliament_request.people.members },
      current: proc { ParliamentHelper.parliament_request.people.members.current },
      letters: proc { |params| ParliamentHelper.parliament_request.people.members(params[:letter]) },
      current_letters: proc { |params| ParliamentHelper.parliament_request.people.members.current(params[:letter]) },
      a_to_z: proc { ParliamentHelper.parliament_request.people.members.a_z_letters },
      a_to_z_current: proc { ParliamentHelper.parliament_request.people.members.current.a_z_letters }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
