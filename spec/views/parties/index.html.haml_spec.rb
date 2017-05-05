require 'rails_helper'

RSpec.describe 'parties/index', vcr: true do
  before do
    assign(:people, [])
    assign(:parties, [double(:party, name: 'Conservative', graph_id: 'jF43Jxoc')])
    assign(:letters, 'A')
    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current and former parties and groups/)
    end
  end

  context 'partials' do
    it 'will render pugin/components/_navigation-letter' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render _party_list' do
      expect(response).to render_template(partial: '_party_list')
    end
  end
end
