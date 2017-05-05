require 'rails_helper'

RSpec.describe 'houses/index', vcr: true do
  before do
    assign(:houses, [double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP')])
    render
  end

  context 'header' do
    it 'will render the page title' do
      expect(rendered).to match(/Houses/)
    end
  end

  context 'links' do
    it 'will render house_path' do
      expect(rendered).to have_link('House of Commons', href: house_path('KL2k1BGP'))
    end
  end
end
