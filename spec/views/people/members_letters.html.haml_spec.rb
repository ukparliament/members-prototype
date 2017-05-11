require 'rails_helper'

RSpec.describe 'people/members_letters', vcr: true do
  before do
    assign(:people, [])
    assign(:letters, 'A')
    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current and former MPs and Lords/)
    end
  end

  context 'partials' do
    it 'will render pugin/components/_navigation-letter' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render pugin/cards/person-list' do
      expect(response).to render_template(partial: 'pugin/cards/_person-list')
    end
  end
end
