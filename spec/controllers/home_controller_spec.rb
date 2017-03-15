require 'rails_helper'

RSpec.describe HomeController, vcr: true do

  context 'it returns a response' do

    describe 'GET index' do
      before(:each) do
        get :index
      end

      it 'should render index page' do
        expect(response).to render_template("index")
      end

      context 'it should ids for both house of commons and house of lords' do
         it 'it should return house of commons id' do
           expect(assigns(:commons_id)).to eq('4b77dd58-f6ba-4121-b521-c8ad70465f52')
         end

         it 'should return house of lords id' do
           expect(assigns(:lords_id)).to eq('f1a325bf-f550-48a5-ad40-e30cb7b7bdf4')
         end
      end

    end
  end

  context 'it does not return a response' do
    it 'and should raise an error' do
       expect{ get :index }.to raise_error(ActionController::RoutingError)
    end
  end

end
