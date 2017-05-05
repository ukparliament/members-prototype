require 'rails_helper'

RSpec.describe 'meta/index', vcr: true do
  before do
    assign(:meta_routes, [url: 'meta/cookie-policy', translation: 'cookie-policy'])
    render
  end

  it 'will render meta routes' do
    expect(rendered).to have_link('Cookies', href: 'meta/cookie-policy')
  end
end
