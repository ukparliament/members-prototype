require 'rails_helper'

RSpec.describe HomeController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render index page' do
      expect(response).to render_template('index')
    end
  end
end
