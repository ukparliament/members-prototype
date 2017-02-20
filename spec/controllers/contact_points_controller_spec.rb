require 'rails_helper'

RSpec.describe ContactPointsController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @contact_points' do
      assigns(:contact_points).each do |contact_point|
        expect(contact_point).to be_a(Grom::Node)
        expect(contact_point.type).to eq('http://id.ukpds.org/schema/ContactPoint')
      end
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    it 'should have a response with a http status ok (200)' do
      get :show, params: { contact_point_id: 'a11425ca-6a47-4170-80b9-d6e9f3800a52' }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @contact' do
      get :show, params: { contact_point_id: 'a11425ca-6a47-4170-80b9-d6e9f3800a52' }
      expect(assigns(:contact_point)).to be_a(Grom::Node)
      expect(assigns(:contact_point).type).to eq('http://id.ukpds.org/schema/ContactPoint')
    end

    describe 'download' do
      card = "BEGIN:VCARD\nVERSION:3.0\nEMAIL:walpolerh@parliament.uk\nN:;;;;\nFN:\nEND:VCARD\n"
      file_options = { filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false } }

      before do
        expect(controller).to receive(:send_data).with(card, file_options) { controller.head :ok }
      end

      it 'should download a vcard attachment' do
        get :show, params: { contact_point_id: 'a11425ca-6a47-4170-80b9-d6e9f3800a52' }
      end
    end
  end
end
