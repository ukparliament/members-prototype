require 'rails_helper'

RSpec.describe 'routes', type: :routing do
  describe '#listable' do
    context 'id_format_regex' do
      context 'matches regex' do
        it 'GET people#show' do
          expect(get: '/people/B4qvo8kI').to route_to(
            controller: 'people',
            action:     'show',
            person_id:  'B4qvo8kI'
          )
        end
      end
      context 'does not match regex' do
        it 'GET people#lookup_by_letters' do
          expect(get: '/people/a').to route_to(
            controller: 'people',
            action:     'lookup_by_letters',
            letters:    'a'
          )
        end
      end
    end
  end
end
