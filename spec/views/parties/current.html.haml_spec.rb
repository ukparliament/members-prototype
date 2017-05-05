require 'rails_helper'

RSpec.describe 'parties/current', vcr: true do
  before do
    allow(FlagHelper).to receive(:dissolution?).and_return(true)
    assign(:parties, [])
    assign(:letters, 'A')
    assign(:party_id, 'jF43Jxoc')
    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current parties and groups/)
    end
  end

  context 'partials' do
    it 'will render _party_list' do
      expect(response).to render_template(partial: '_party_list')
    end

    it 'will render dissolution message' do
      expect(response).to render_template(partial: 'shared/_dissolution_message')
    end
  end
end
