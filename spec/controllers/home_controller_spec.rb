require 'rails_helper'

RSpec.describe HomeController do

  describe 'GET index' do

    it 'should render index page' do
      get :index
      expect(response).to render_template("index")
    end

  end
end
