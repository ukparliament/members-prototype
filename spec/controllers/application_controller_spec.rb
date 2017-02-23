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

# a test for rescue_from NoContentError can be found in people_controller_spec
# placed it here as it needed testing in an actual controller
