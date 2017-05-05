require 'rails_helper'

RSpec.describe 'shared/_dissolution_message', vcr: true do
  context 'content' do
    before do
      allow(FlagHelper).to receive(:dissolution?).and_return(true)
      render
    end

    it 'will render the disolution message' do
      expect(rendered).to match(/dissolved/)
    end
  end
end
