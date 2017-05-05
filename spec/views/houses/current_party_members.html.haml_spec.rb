require 'rails_helper'

RSpec.describe 'houses/current_party_members', vcr: true do
  before do
    allow(FlagHelper).to receive(:dissolution?).and_return(true)
    assign(:house, double(:house, name: 'Test House', graph_id: 'KL2k1BGP'))
    assign(:people, [])
    assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'))
    assign(:current_person_type, 'MPs')
    assign(:other_person_type, 'Lords')
    assign(:other_house_id, 'KL2k1BGP')
    assign(:house_id, 'KL2k1BGP')
    assign(:party_id, 'jF43Jxoc')
    assign(:letters, 'A')
    controller.params = { letter: 'a' }

    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Conservative - Current MPs/)
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
    it 'will render house_parties_party_members_a_z_letter_path' do
      expect(rendered).to have_link('View all current and former members', href: house_parties_party_members_a_z_letter_path('KL2k1BGP', 'jF43Jxoc', 'a'))
    end
  end
end
