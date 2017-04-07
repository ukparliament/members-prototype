require 'rails_helper'

RSpec.describe 'houses', type: :routing do
  describe 'HousesController' do
    include_examples 'index route', 'houses'

    # houses#lookup
    include_examples 'top level routes', 'houses', 'lookup'

    context 'house' do
      # houses#show
      include_examples 'nested routes with an id', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', [], 'show'

      context 'members' do
        # houses#members
        include_examples 'nested routes with an id', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', ['members'], 'members'

        # houses#a_to_z_members
        include_examples 'nested routes with an id', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', ['members', 'a-z'], 'a_to_z_members'

        # houses#current_members
        include_examples 'nested routes with an id', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', %w(members current), 'current_members'

        # houses#a_to_z_current_members
        include_examples 'nested routes with an id', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', ['members', 'current', 'a-z'], 'a_to_z_current_members'

        # houses#members_letters
        include_examples 'a_to_z route with an id and letter', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', ['members', 'a-z'], 'members_letters', 'a'

        # houses#current_members_letters
        include_examples 'a_to_z route with an id and letter', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', ['members', 'current', 'a-z'], 'current_members_letters', 'a'
      end

      context 'parties' do
        # houses#parties
        include_examples 'nested routes with an id', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', ['parties'], 'parties'

        # houses#current_parties
        include_examples 'nested routes with an id', 'houses', '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703', %w(parties current), 'current_parties'

        it 'GET houses#party' do
          expect(get: '/houses/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/parties/f4e62fb8-2cf4-41b2-b7a3-7e621522a30d').to route_to(
            controller: 'houses',
            action:     'party',
            house_id:   '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703',
            party_id:   'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d'
          )
        end

        it 'GET houses#party_members' do
          expect(get: '/houses/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/parties/f4e62fb8-2cf4-41b2-b7a3-7e621522a30d/members').to route_to(
            controller: 'houses',
            action:     'party_members',
            house_id:   '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703',
            party_id:   'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d'
          )
        end

        it 'GET houses#a_to_z_party_members' do
          expect(get: '/houses/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/parties/f4e62fb8-2cf4-41b2-b7a3-7e621522a30d/members/a-z').to route_to(
            controller: 'houses',
            action:     'a_to_z_party_members',
            house_id:   '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703',
            party_id:   'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d'
          )
        end

        it 'GET houses#party_members_letters' do
          expect(get: '/houses/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/parties/f4e62fb8-2cf4-41b2-b7a3-7e621522a30d/members/a-z/a').to route_to(
            controller: 'houses',
            action:     'party_members_letters',
            house_id:   '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703',
            party_id:   'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d',
            letter:     'a'
          )
        end

        it 'GET houses#current_party_members' do
          expect(get: '/houses/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/parties/f4e62fb8-2cf4-41b2-b7a3-7e621522a30d/members/current').to route_to(
            controller: 'houses',
            action:     'current_party_members',
            house_id:   '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703',
            party_id:   'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d'
          )
        end

        it 'GET houses#a_to_z_current_party_members' do
          expect(get: '/houses/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/parties/f4e62fb8-2cf4-41b2-b7a3-7e621522a30d/members/current/a-z').to route_to(
            controller: 'houses',
            action:     'a_to_z_current_party_members',
            house_id:   '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703',
            party_id:   'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d'
          )
        end

        it 'GET houses#a_to_z_current_party_members' do
          expect(get: '/houses/9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703/parties/f4e62fb8-2cf4-41b2-b7a3-7e621522a30d/members/current/a-z/a').to route_to(
            controller: 'houses',
            action:     'current_party_members_letters',
            house_id:   '9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703',
            party_id:   'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d',
            letter:     'a'
          )
        end

        it 'GET houses#lookup_by_letters' do
          expect(get: '/houses/a').to route_to(
            controller: 'houses',
            action:     'lookup_by_letters',
            letters:    'a'
          )
        end
      end
    end
  end
end
