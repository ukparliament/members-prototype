require 'rails_helper'

RSpec.describe 'constituencies', type: :routing do
  describe 'ConstituenciesController' do
    include_examples 'index route', 'constituencies'

    # constituencies#lookup
    include_examples 'top level routes', 'constituencies', 'lookup'

    # constituencies#current
    include_examples 'top level routes', 'constituencies', 'current'

    # constituencies#a_to_z
    include_examples 'nested collection routes', 'constituencies', ['a-z'], 'a_to_z'

    # constituencies#a_to_z_current
    include_examples 'nested collection routes', 'constituencies', ['current', 'a-z'], 'a_to_z_current'

    # constituencies#letters
    include_examples 'collection a_to_z route with a letter', 'constituencies', ['a-z'], 'letters', 'a'

    # constituencies#current_letters
    include_examples 'collection a_to_z route with a letter', 'constituencies', ['current', 'a-z'], 'current_letters', 'a'

    context 'constituency' do
      # constituencies#show
      include_examples 'nested routes with an id', 'constituencies', 'MtbjxRrE', [], 'show'

      # constituencies#contact_point
      include_examples 'nested routes with an id', 'constituencies', 'MtbjxRrE', ['contact-point'], 'contact_point'

      # constituencies#map
      include_examples 'nested routes with an id', 'constituencies', 'MtbjxRrE', ['map'], 'map'

      # constituencies#members
      include_examples 'nested routes with an id', 'constituencies', 'MtbjxRrE', ['members'], 'members'

      # constituencies#current_member
      include_examples 'nested routes with an id', 'constituencies', 'MtbjxRrE', %w(members current), 'current_member'
    end

    it 'GET constituencies#lookup_by_letters' do
      expect(get: '/constituencies/a').to route_to(
        controller: 'constituencies',
        action:     'lookup_by_letters',
        letters:    'a'
      )
    end
  end
end
