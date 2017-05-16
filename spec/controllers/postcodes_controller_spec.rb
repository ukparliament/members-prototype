require 'rails_helper'

RSpec.describe PostcodesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    context 'given a valid postcode' do
      before(:each) do
        get :show, params: { postcode: 'SW1A 2AA' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @postcode and @constituency' do
        expect(assigns(:postcode)).to eq('SW1A 2AA')
        expect(assigns(:constituency).name).to eq('constituencyGroupName - 1')
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end

    context 'given an invalid postcode, but in the correct postcode format' do
      before(:each) do
        PostcodeHelper.previous_path = constituencies_current_path

        get :show, params: { postcode: 'AA99 2AA' }
      end

      it 'assigns flash[:error]' do
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end

      it 'redirects to constituencies_current' do
        expect(response).to redirect_to(constituencies_current_path)
      end
    end

    context 'given an invalid postcode' do
      before(:each) do
        PostcodeHelper.previous_path = constituencies_current_path

        get :show, params: { postcode: 'apple' }
      end

      it 'assigns flash[:error]' do
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end

      it 'redirects to constituencies_current' do
        expect(response).to redirect_to(constituencies_current_path)
      end
    end
  end

  describe 'POST lookup' do
    context 'given a valid postcode' do
      before(:each) do
        post :lookup, params: { postcode: 'SW1A 2AA' }
      end

      it 'redirects to show' do
        expect(response).to redirect_to(postcode_path('SW1A-2AA'))
      end
    end

    context 'given a blank postcode' do
      before(:each) do
        post :lookup, params: { postcode: '', previous_path: postcodes_path }
      end

      it 'assigns flash[:error]' do
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end

      it 'redirects to postcodes index' do
        expect(response).to redirect_to(postcodes_path)
      end
    end
  end
end
