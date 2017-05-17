require 'rails_helper'

RSpec.describe 'postcodes/_postcode_lookup', vcr: true do
  before do
    render partial: 'postcodes/postcode_lookup', locals: { path: '/people/7TX8ySd4', flash: { error: 'Test Error Flash Message', postcode: '1111111' } }
  end

  context 'flash' do
    it 'will render flash message' do
      expect(rendered).to match('Test Error Flash Message')
    end
  end

  it 'will have postcode instructions' do
    expect(rendered).to match(/Enter your full postcode, for example SW1A 0AA/)
  end

  context 'postcode form' do
    it 'will render form to path' do
      expect(rendered).to match(/form action="\/people\/7TX8ySd4\"/)
    end
  end

  context 'links' do
    it 'will render link to Royal Mail' do
      expect(rendered).to have_link('Royal Mail postcode finder', href: 'http://www.royalmail.com/find-a-postcode')
      expect(rendered).to match(/title="website opens in a new window"/)
    end
  end

  it 'will repopulate the form if the user enters an invalid postcode' do
    expect(rendered).to match('1111111')
  end
end
