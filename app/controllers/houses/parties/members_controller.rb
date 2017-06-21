module Houses
  module Parties
    class MembersController < ApplicationController
      before_action :data_check

      def index
        house_id = params[:house_id]
        party_id = params[:party_id]

        @house, @party, @people, @letters = RequestHelper.filter_response_data(
        parliament_request.houses(house_id).parties(party_id).members,
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )
        @house = @house.first
        @party = @party.first
        @people = @people.sort_by(:sort_name)
        @letters = @letters.map(&:value)
        @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
      end

      def letters
        house_id = params[:house_id]
        party_id = params[:party_id]
        letter = params[:letter]

        @house, @party, @people, @letters = RequestHelper.filter_response_data(
        parliament_request.houses(house_id).parties(party_id).members(letter),
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )
        @house = @house.first
        @party = @party.first
        @people = @people.sort_by(:sort_name)
        @letters = @letters.map(&:value)
        @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
      end

      def current
        house_id = params[:house_id]
        party_id = params[:party_id]

        @house, @party, @people, @letters = RequestHelper.filter_response_data(
        parliament_request.houses(house_id).parties(party_id).members.current,
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )

        @house = @house.first
        @party = @party.first
        @people = @people.sort_by(:sort_name)
        @letters = @letters.map(&:value)
        @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
      end

      def current_letters
        house_id = params[:house_id]
        party_id = params[:party_id]
        letter = params[:letter]

        @house, @party, @people, @letters = RequestHelper.filter_response_data(
        parliament_request.houses(house_id).parties(party_id).members.current(letter),
        'http://id.ukpds.org/schema/House',
        'http://id.ukpds.org/schema/Party',
        'http://id.ukpds.org/schema/Person',
        ::Grom::Node::BLANK
        )

        @house = @house.first
        @party = @party.first
        @people = @people.sort_by(:sort_name)
        @letters = @letters.map(&:value)
        @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
      end

      def a_to_z
        @house_id = params[:house_id]
        @party_id = params[:party_id]

        @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).parties(@party_id).members.a_z_letters)
      end

      def a_to_z_current
        @house_id = params[:house_id]
        @party_id = params[:party_id]

        @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).parties(@party_id).members.current.a_z_letters)
      end

      private

      ROUTE_MAP = {
        index: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]).members },
        a_to_z_current: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]).members.current.a_z_letters },
        current: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]).members.current },
        letters: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]).members(params[:letter]) },
        current_letters: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]).members.current(params[:letter]) },
        a_to_z: proc { |params| ParliamentHelper.parliament_request.houses(params[:house_id]).parties(params[:party_id]).members.a_z_letters }
      }.freeze

      def data_url
        ROUTE_MAP[params[:action].to_sym]
      end
    end
  end
end
