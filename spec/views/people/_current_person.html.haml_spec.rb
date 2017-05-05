require 'rails_helper'

RSpec.describe 'people/_current_person', vcr: true do
  before do
    current_person = double(:current_person,
      full_name:      'Person Full Name',
      graph_id:       '7TX8ySd4',
      houses:         [double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP')],
      constituencies: [double(:constituency, name: 'Test Constituency', graph_id: 'x45XdVJD')],
      parties:        [double(:party, name: 'Test Party', graph_id: 'jF43Jxoc')])

    render partial: 'people/current_person', locals: { current_person: current_person }
  end

  context 'links' do
    it 'will link to person_path' do
      expect(rendered).to have_link('Person Full Name', href: person_path('7TX8ySd4'))
    end

    it 'will link to house_path' do
      expect(rendered).to have_link('House of Commons', href: house_path('KL2k1BGP'))
    end

    it 'will link to constituency_path' do
      expect(rendered).to have_link('Test Constituency', href: constituency_path('x45XdVJD'))
    end

    it 'will link to party_path' do
      expect(rendered).to have_link('Test Party', href: party_path('jF43Jxoc'))
    end
  end
end
