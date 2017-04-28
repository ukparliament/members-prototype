require 'rails_helper'

RSpec.describe 'parties', type: :routing do
  describe 'PartiesController' do
    include_examples 'index route', 'parties'

    # parties#current
    include_examples 'top level routes', 'parties', 'current'

    # parties#lookup
    include_examples 'top level routes', 'parties', 'lookup'

    # parties#a_to_z
    include_examples 'nested collection routes', 'parties', ['a-z'], 'a_to_z'

    # parties#letters
    include_examples 'collection a_to_z route with a letter', 'parties', ['a-z'], 'letters', 'a'

    context 'party' do
      # parties#show
      include_examples 'nested routes with an id', 'parties', 'jF43Jxoc', [], 'show'

      # parties#members
      include_examples 'nested routes with an id', 'parties', 'jF43Jxoc', ['members'], 'members'

      # parties#a_to_z_members
      include_examples 'nested routes with an id', 'parties', 'jF43Jxoc', ['members', 'a-z'], 'a_to_z_members'

      # parties#current_members
      include_examples 'nested routes with an id', 'parties', 'jF43Jxoc', %w(members current), 'current_members'

      # parties#a_to_z_current_members
      include_examples 'nested routes with an id', 'parties', 'jF43Jxoc', ['members', 'current', 'a-z'], 'a_to_z_current_members'

      # parties#members_letters
      include_examples 'a_to_z route with an id and letter', 'parties', 'jF43Jxoc', ['members', 'a-z'], 'members_letters', 'a'

      # parties#current_members_letters
      include_examples 'a_to_z route with an id and letter', 'parties', 'jF43Jxoc', ['members', 'current', 'a-z'], 'current_members_letters', 'a'
    end

    it 'GET parties#lookup_by_letters' do
      expect(get: '/parties/a').to route_to(
        controller: 'parties',
        action:     'lookup_by_letters',
        letters:    'a'
      )
    end
  end
end
