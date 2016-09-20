require 'rails_helper'

feature 'index page' do
  context 'when visiting the home page' do
    before(:each) do
      stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people.json").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => PEOPLE_HASH.to_json, :headers => {})

      stub_request(:get, "#{MembersPrototype::Application.config.endpoint}/people.ttl").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>"#{MembersPrototype::Application.config.endpoint_host}", 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => PEOPLE_TTL, :headers => {})

      visit people_path
    end

    scenario 'should show a list of all people' do
      expect(page).to have_content('People')
      expect(page).to have_selector('li', count: 5)
    end

    scenario 'the first person in the list should have name Member1' do
      expect(page).to have_link('Member1')
    end
  end
end
