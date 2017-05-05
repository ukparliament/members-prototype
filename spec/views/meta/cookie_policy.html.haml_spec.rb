require 'rails_helper'

RSpec.describe 'meta/cookie_policy', vcr: true do
  before do
    render
  end

  it 'will render the header' do
    expect(rendered).to match(/Cookies/)
  end

  context 'links' do
    it "will render link to 'http://www.aboutcookies.org/'" do
      expect(rendered).to have_link('manage and delete cookies', href: 'http://www.aboutcookies.org/')
    end

    it "will render link to 'https://tools.google.com/dlpage/gaoptout'" do
      expect(rendered).to have_link('opt out of Google Analytics cookies', href: 'https://tools.google.com/dlpage/gaoptout')
    end
  end
end
