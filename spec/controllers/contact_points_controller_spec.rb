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

    describe '#data_check' do
      context 'an available data format is requested' do
        methods = [
            {
              route: 'index',
              data_url: "#{ENV['PARLIAMENT_BASE_URL']}/contact_points"
            },
            {
              route: 'show',
              parameters: { contact_point_id: 'fFm9NQmr' },
              data_url: "#{ENV['PARLIAMENT_BASE_URL']}/contact_points/fFm9NQmr"
            }
          ]

        before(:each) do
          headers = { 'Accept' => 'application/rdf+xml' }
          request.headers.merge(headers)
        end

        it 'should have a response with http status redirect (302)' do
          methods.each do |method|
            if method.include?(:parameters)
              get method[:route].to_sym, params: method[:parameters]
            else
              get method[:route].to_sym
            end
            expect(response).to have_http_status(302)
          end
        end

        it 'redirects to the data service' do
          methods.each do |method|
            if method.include?(:parameters)
              get method[:route].to_sym, params: method[:parameters]
            else
              get method[:route].to_sym
            end
            expect(response).to redirect_to(method[:data_url])
          end
        end

      end
    end

  end
end
