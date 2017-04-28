require 'rails_helper'

RSpec.describe 'meta', type: :routing do
  describe 'MetaController' do
    include_examples 'index route', 'meta'

    context 'cookie policy' do
      it 'GET meta#cookie_policy' do
        expect(get: '/meta/cookie-policy').to route_to(
          controller: 'meta',
          action:     'cookie_policy'
        )
      end
    end
  end
end
