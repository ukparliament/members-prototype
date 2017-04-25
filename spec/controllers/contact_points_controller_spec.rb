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
      get :show, params: { contact_point_id: 'fFm9NQmr' }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @contact_point' do
      get :show, params: { contact_point_id: 'fFm9NQmr' }
      expect(assigns(:contact_point)).to be_a(Grom::Node)
      expect(assigns(:contact_point).type).to eq('http://id.ukpds.org/schema/ContactPoint')
    end

    describe 'download' do
      card = "BEGIN:VCARD\nVERSION:3.0\nADR:;;addressLine1 - 1\\, addressLine2 - 1\\, postCode - 1;;;;\nEMAIL:email - 1\nTEL:phoneNumber - 1\nTEL;TYPE=fax:faxNumber - 1\nN:personFamilyName - 1;personGivenName - 1;;;\nFN:personGivenName - 1 personFamilyName - 1\nEND:VCARD\n"
      file_options = { filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false } }

      before do
        expect(controller).to receive(:send_data).with(card, file_options) { controller.head :ok }
      end

      it 'should download a vcard attachment' do
        get :show, params: { contact_point_id: 'fFm9NQmr' }
      end
    end
  end
end
