require 'rails_helper'

RSpec.describe 'postcodes/index', vcr: true do
  before do
    render
  end

  context 'partials' do
    it 'will render postcode_lookup' do
      expect(response).to render_template(partial: '_postcode_lookup')
    end
  end
end
