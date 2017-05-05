require 'rails_helper'

RSpec.describe 'shared/_empty_list', vcr: true do
  context 'content' do
    before do
      render partial: 'shared/empty_list', locals: { title: 'Test Title', description: 'Test Description' }
    end

    it 'will render the title' do
      expect(rendered).to match(/Test Title/)
    end

    it 'will render the description' do
      expect(rendered).to match(/Test Description/)
    end
  end
end
