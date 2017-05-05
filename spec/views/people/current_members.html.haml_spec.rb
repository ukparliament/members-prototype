require 'rails_helper'

RSpec.describe 'people/current_members', vcr: true do
  before do
    allow(FlagHelper).to receive(:dissolution?).and_return(true)
    assign(:people, [])
    assign(:letters, 'A')
    controller.params = { letter: 'a' }
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Current MPs and Lords/)
    end
  end

  context 'partials' do
    it 'will render pugin/components/_navigation-letter' do
      expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
    end

    it 'will render pugin/cards/person-list' do
      expect(response).to render_template(partial: 'pugin/cards/_person-list')
    end

    it 'will render dissolution message' do
      expect(response).to render_template(partial: 'shared/_dissolution_message')
    end
  end
end
