require 'rails_helper'

RSpec.describe 'constituencies/current_letters', vcr: true do
  before do
    allow(FlagHelper).to receive(:dissolution?).and_return(true)
    assign(:constituencies, [])
    assign(:letters, 'A')
    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current constituencies/)
    end
  end

  context 'partials' do
    it 'will render pugin/components/_navigation-letter' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render constituencies/current_constituencies' do
      expect(response).to render_template('constituencies/_current_constituencies')
    end

    it 'will render dissolution message' do
      expect(response).to render_template(partial: 'shared/_dissolution_message')
    end
  end
end
