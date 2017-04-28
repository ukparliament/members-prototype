require 'rails_helper'

RSpec.describe 'people', type: :routing do
  describe 'PeopleController' do
    context 'people' do
      include_examples 'index route', 'people'

      # people#lookup
      include_examples 'top level routes', 'people', 'lookup'
      # people#member
      include_examples 'top level routes', 'people', 'members'

      # people#a_to_z
      include_examples 'nested collection routes', 'people', ['a-z'], 'a_to_z'

      # people#a_to_z_members
      include_examples 'nested collection routes', 'people', ['members', 'a-z'], 'a_to_z_members'

      # people#current_members
      include_examples 'nested collection routes', 'people', %w(members current), 'current_members'

      # people#a_to_z_current_members
      include_examples 'nested collection routes', 'people', ['members', 'current', 'a-z'], 'a_to_z_current_members'

      # people#members_letters
      include_examples 'collection a_to_z route with a letter', 'people', ['members', 'a-z'], 'members_letters', 'a'

      # people#letters
      include_examples 'collection a_to_z route with a letter', 'people', ['a-z'], 'letters', 'a'

      # people#current_members_letters
      include_examples 'collection a_to_z route with a letter', 'people', ['members', 'current', 'a-z'], 'current_members_letters', 'a'

      it 'GET people#lookup_by_letters' do
        expect(get: '/people/a').to route_to(
          controller: 'people',
          action:     'lookup_by_letters',
          letters:    'a'
        )
      end
    end

    context 'person' do
      # people#show
      include_examples 'nested routes with an id', 'people', 'B4qvo8kI', [], 'show'

      context 'constituencies' do
        # people#costituencies
        include_examples 'nested routes with an id', 'people', 'B4qvo8kI', ['constituencies'], 'constituencies'

        # people#current_constituency
        include_examples 'nested routes with an id', 'people', 'B4qvo8kI', %w(constituencies current), 'current_constituency'
      end

      context 'contact points' do
        # people#contact_points
        include_examples 'nested routes with an id', 'people', 'B4qvo8kI', ['contact-points'], 'contact_points'
      end

      context 'houses' do
        # people#houses
        include_examples 'nested routes with an id', 'people', 'B4qvo8kI', ['houses'], 'houses'

        # people#current_house
        include_examples 'nested routes with an id', 'people', 'B4qvo8kI', %w(houses current), 'current_house'
      end

      context 'parties' do
        # people#parties
        include_examples 'nested routes with an id', 'people', 'B4qvo8kI', ['parties'], 'parties'

        # people#current_party
        include_examples 'nested routes with an id', 'people', 'B4qvo8kI', %w(parties current), 'current_party'
      end
    end
  end
end
