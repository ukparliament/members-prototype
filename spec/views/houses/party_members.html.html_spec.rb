require 'rails_helper'

RSpec.describe 'houses/party_members', vcr: true do
  before do
    assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'))
    assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', member_count: 10))
    assign(:people, [])
    assign(:current_person_type, 'MPs')
    assign(:letters, 'A')
    controller.params = { letter: 'a' }

    render
  end

  context 'header' do
    it 'will render the page title' do
      expect(rendered).to match(/Conservative - Current and former MPs/)
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
