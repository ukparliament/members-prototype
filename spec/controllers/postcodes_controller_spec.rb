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

      it 'assigns flash[:postcode]' do
        expect(flash[:postcode]).to eq("apple")
      end

      it 'redirects to constituencies_current' do
        expect(response).to redirect_to(constituencies_current_path)
      end
    end

    context 'given a xss search' do
      before(:each) do
        PostcodeHelper.previous_path = constituencies_current_path

        get :show, params: { postcode: '<script>alert(document.cookie)</script>' }
      end

      it 'assigns xss flash[:error]' do
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end

      it 'assigns xss flash[:postcode]' do
        expect(flash[:postcode]).to eq('alert(document.cookie)')
      end

      it 'redirects xss to constituencies_current' do
        expect(response).to redirect_to(constituencies_current_path)
      end
    end
  end

  describe 'POST lookup' do
    context 'given a valid postcode' do
      before(:each) do
        post :lookup, params: { postcode: 'SW1A 2AA', previous_controller: 'postcodes', previous_action: 'index' }
      end

      it 'redirects to show' do
        expect(response).to redirect_to(postcode_path('SW1A-2AA'))
      end
    end

    context 'given a blank postcode' do
      before(:each) do
        post :lookup, params: { postcode: '', previous_controller: 'postcodes', previous_action: 'index' }
      end

      it 'assigns flash[:error]' do
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end

      it 'redirects to postcodes index' do
        expect(response).to redirect_to(postcodes_path)
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
        get :show, params: { postcode: 'SW1A2AA' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to the data service' do
        expect(response).to redirect_to("#{ENV['PARLIAMENT_BASE_URL']}/constituencies/postcode_lookup/SW1A2AA")
      end
    end

    context 'no data available' do
      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'GET index should raise an error' do
        expect{get :index}.to raise_error(StandardError, 'Data URL does not exist')
        expect(response).not_to have_http_status(302)
      end

      it 'GET lookup should raise an error' do
        expect{get :lookup, params: { postcode: 'SW1A 2AA', previous_controller: 'postcodes', previous_action: 'index' }}.to raise_error(StandardError, 'Data URL does not exist')
        expect(response).not_to have_http_status(302)
      end
    end
  end

end
