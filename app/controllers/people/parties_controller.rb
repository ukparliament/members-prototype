module People
  class PartiesController < ApplicationController
    before_action :data_check

    def index
      @person, @party_memberships = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call(params),
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/PartyMembership'
      )

      @person = @person.first
      @party_memberships = @party_memberships.reverse_sort_by(:start_date)
    end

    def current
      @person, @party = RequestHelper.filter_response_data(
      ROUTE_MAP[:current].call(params),
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/Party'
      )

      @person = @person.first
      @party = @party.first
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.people(params[:person_id]).parties },
      current: proc { |params| ParliamentHelper.parliament_request.people(params[:person_id]).parties.current }
    }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
