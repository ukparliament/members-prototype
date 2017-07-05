require 'rails_helper'

RSpec.describe 'people', type: :routing do
  describe 'PeopleController' do
    context 'people' do
      include_examples 'index route', 'people'

      # people#lookup
      include_examples 'top level routes', 'people', 'lookup'

      # people#postcode_lookup
      include_examples 'top level POST routes', 'people', 'postcode_lookup'

      # people#a_to_z
      include_examples 'nested collection routes', 'people', ['a-z'], 'a_to_z'

      # people#letters
      include_examples 'collection a_to_z route with a letter', 'people', ['a-z'], 'letters', 'a'

      # people/members#current_members_letters
      include_examples 'collection a_to_z route with a letter', 'people/members', ['current', 'a-z'], 'current_letters', 'a'

      # people/members#a_to_z_members
      include_examples 'nested collection routes', 'people/members', ['a-z'], 'a_to_z'

      # people/members#current_members
      include_examples 'nested collection routes', 'people/members', ['current'], 'current'

      # people/members#a_to_z_current_members
      include_examples 'nested collection routes', 'people/members', ['current', 'a-z'], 'a_to_z_current'

      # people/members#members_letters
      include_examples 'collection a_to_z route with a letter', 'people/members', ['a-z'], 'letters', 'a'

      it 'GET people#lookup_by_letters' do
        expect(get: '/people/a').to route_to(
          controller: 'people',
          action:     'lookup_by_letters',
          letters:    'a'
        )
      end

      it 'GET people/members#index' do
        expect(get: '/people/members').to route_to(
          controller: 'people/members',
          action:     'index'
        )
      end
    end

    context 'person' do
      # people#show
      include_examples 'nested routes with an id', 'people', 'B4qvo8kI', [], 'show'

      context 'constituencies' do
        it 'GET people/:person_id/constituencies' do
          expect(get: '/people/B4qvo8kI/constituencies').to route_to(
            controller: 'people/constituencies',
            action:     'index',
            person_id:    'B4qvo8kI'
          )
        end

        it 'GET people/:person_id/constituencies/current' do
          expect(get: '/people/B4qvo8kI/constituencies/current').to route_to(
            controller: 'people/constituencies',
            action:     'current',
            person_id:    'B4qvo8kI'
          )
        end

      end

      context 'contact points' do
        # people/contact_points#index
        it 'GET people/:person_id/contact_points' do
          expect(get: '/people/B4qvo8kI/contact-points').to route_to(
            controller: 'people/contact_points',
            action:     'index',
            person_id:    'B4qvo8kI'
          )
        end
      end

      context 'media' do
        # people/media#show
        it 'GET people/:person_id/media/:media_id' do
          expect(get: '/people/7TX8ySd4/media/XXXX').to route_to(
            controller: 'people/media',
            action:     'show',
            person_id:    '7TX8ySd4',
            media_id: 'XXXX'
          )
        end
      end

      context 'houses' do

        it 'GET people/:person_id/houses' do
          expect(get: '/people/B4qvo8kI/houses').to route_to(
            controller: 'people/houses',
            action:     'index',
            person_id:    'B4qvo8kI'
          )
        end

        it 'GET people/:person_id/houses/current' do
          expect(get: '/people/B4qvo8kI/houses/current').to route_to(
            controller: 'people/houses',
            action:     'current',
            person_id:    'B4qvo8kI'
          )
        end

      end

      context 'parties' do

        it 'GET people/:person_id/parties' do
          expect(get: '/people/B4qvo8kI/parties').to route_to(
            controller: 'people/parties',
            action:     'index',
            person_id:    'B4qvo8kI'
          )
        end

        it 'GET people/:person_id/parties/current' do
          expect(get: '/people/B4qvo8kI/parties/current').to route_to(
            controller: 'people/parties',
            action:     'current',
            person_id:    'B4qvo8kI'
          )
        end
      end
    end
  end
end
