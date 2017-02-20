require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'GET a_to_z' do
    before(:each) do
      get :a_to_z
    end

    it 'assigns @root_path' do
      expect(assigns(:root_path)).to be_a(String)
      expect(assigns(:root_path)).to eq('/people/a-z')
    end
  end
end
