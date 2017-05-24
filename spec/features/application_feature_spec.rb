require 'rails_helper.rb'

RSpec.describe 'trailing slashes', vcr: true, :type => :feature do
  it 'removes trailing slashes from url' do
    visit '/people/'
    expect(current_path).to eq('/people')
  end

  it 'does not add trailing slash' do
    visit '/people'
    expect(current_path).to eq('/people')
  end
end
