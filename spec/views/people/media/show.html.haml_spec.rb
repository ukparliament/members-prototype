require 'rails_helper'

RSpec.describe 'people/media/show', vcr: true do
  before do
    assign(:person, double(:person, display_name: 'Test Name', image_id: 'XXXX'))

    render
  end

  context 'display name' do
    it 'will render the correct display name' do
      expect(rendered).to match(/Test Name/)
    end
  end
end
