require 'rails_helper'

RSpec.describe 'houses/current_members', vcr: true do
  before do
    allow(FlagHelper).to receive(:dissolution?).and_return(true)
    assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'))
    assign(:people, [])
    assign(:current_person_type, 'MPs')
    assign(:other_person_type, 'Lords')
    assign(:other_house_id, 'm1EgVTLj')
    assign(:house_id, 'KL2k1BGP')
    assign(:party_id, 'jF43Jxoc')
    assign(:letters, 'A')
    controller.params = { letter: 'a' }

    render
  end

  context 'header' do
    it 'will render the current person type' do
      expect(rendered).to match(/Current MPs/)
    end
  end

  context 'partials' do
    it 'will render letter navigation' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render person list' do
      expect(response).to render_template(partial: 'pugin/cards/_person-list')
    end

    it 'will render dissolution message' do
      expect(response).to render_template(partial: 'shared/_dissolution_message')
    end
  end

  context 'links' do
    it 'will render house_members_a_z_letter_path' do
      expect(rendered).to have_link('All current and former MPs', href: house_members_a_z_letter_path('KL2k1BGP', 'a'))
    end
  end
end
