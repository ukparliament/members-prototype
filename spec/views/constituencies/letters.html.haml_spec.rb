require 'rails_helper'

RSpec.describe 'constituencies/letters', vcr: true do
  before do
    assign(:constituencies, [])
    assign(:letters, 'A')
    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current and former constituencies/)
    end
  end

  context 'partials' do
    it 'will render pugin/components/_navigation-letter' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render constituencies/current_constituencies' do
      expect(response).to render_template('constituencies/_constituencies')
    end
  end
end
