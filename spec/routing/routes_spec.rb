require 'rails_helper'

RSpec.describe 'routes', type: :routing do
  describe '#listable' do
    context 'id_format_regex' do
      context 'matches regex' do
        it 'GET people#show' do
          expect(get: '/people/581ade57-3805-4a4a-82c9-8d622cb352a4').to route_to(
            controller: 'people',
            action:     'show',
            person_id:  '581ade57-3805-4a4a-82c9-8d622cb352a4'
          )
        end
      end
      context 'does not match regex' do
        it 'GET people#lookup_by_letters' do
          expect(get: '/people/82c9-8d622cb352a4').to route_to(
            controller: 'people',
            action:     'lookup_by_letters',
            letters:    '82c9-8d622cb352a4'
          )
        end
      end
    end
  end
end
