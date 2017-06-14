require 'rails_helper'

RSpec.describe 'houses/members_letters', vcr: true do
  before do
    assign(:house, double(:house, name: 'Test House', graph_id: 'KL2k1BGP'))
    assign(:people, [])

    assign(:current_person_type, 'MPs')
    assign(:other_person_type, 'Lords')
    assign(:other_house_id, 'KL2k1BGP')
    assign(:house_id, 'KL2k1BGP')
    assign(:party_id, 'pPvA9vKP')
    assign(:letters, 'A')
    controller.params = { letter: 'a' }

    render
  end

  context 'header' do
    it 'will render the page title' do
      expect(rendered).to match(/Current and former MPs/)
    end
  end

  context 'partials' do
    it 'will render letter navigation' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render pugin/elements/_list' do
      expect(response).to render_template('pugin/elements/_list')
    end
  end
end
