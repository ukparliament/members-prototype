require 'rails_helper'

RSpec.describe ErrorsController do

  describe 'GET internal_server_error' do
       it 'should render internal server page' do
         get :internal_server_error
         expect(response).to render_template("internal_server_error")
       end
  end

  describe 'GET not_found' do
    it 'should render not found page' do
      get :not_found
      expect(response).to render_template("not_found")
    end
  end

  describe 'GET no_content' do
    it 'should render no content page' do
      get :no_content
      expect(response).to render_template("no_content")
    end
  end

end
