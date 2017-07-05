require 'rails_helper'

RSpec.describe People::MediaController, vcr: true do
  describe "GET show" do
    before(:each) do
      get :show, params: { person_id: '7TX8ySd4', media_id: '12345678' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
        get :show, params: { person_id: '7TX8ySd4', media_id: '12345678' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to the data service' do
        expect(response).to redirect_to("#{ENV['PARLIAMENT_BASE_URL']}/people/7TX8ySd4/media/12345678")
      end
    end
  end
end
