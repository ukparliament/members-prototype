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
      get :show, params: { contact_point_id: '939d1024-04c3-45b3-96a7-9391c60ab9f2' }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @contact' do
      get :show, params: { contact_point_id: '939d1024-04c3-45b3-96a7-9391c60ab9f2' }
      expect(assigns(:contact_point)).to be_a(Grom::Node)
      expect(assigns(:contact_point).type).to eq('http://id.ukpds.org/schema/ContactPoint')
    end

    describe 'download' do
      #card = "BEGIN:VCARD\nVERSION:3.0\nEMAIL:walpolerh@parliament.uk\nN:;;;;\nFN:\nEND:VCARD\n"
      card = "BEGIN:VCARD\nVERSION:3.0\nADR:;;House of Commons\\, London\\, SW1A 0AA;;;;\nEMAIL:person.one@parliament.uk\nTEL:020 8456 4567\nN:Person 1 familyName;Person 1 givenName;;;\nFN:Person 1 givenName Person 1 familyName\nEND:VCARD\n"
      file_options = { filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false } }

      before do
        expect(controller).to receive(:send_data).with(card, file_options) { controller.head :ok }
      end

      it 'should download a vcard attachment' do
        get :show, params: { contact_point_id: '939d1024-04c3-45b3-96a7-9391c60ab9f2' }
      end
    end
  end
end
