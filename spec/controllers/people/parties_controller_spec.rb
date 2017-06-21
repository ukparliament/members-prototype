require 'rails_helper'

RSpec.describe People::PartiesController, vcr: true do

  describe "GET index" do
    before(:each) do
      get :index, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @party_memberships' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:party_memberships).each do |party_membership|
        expect(party_membership).to be_a(Grom::Node)
        expect(party_membership.type).to eq('http://id.ukpds.org/schema/PartyMembership')
      end
    end

    it 'assigns @party_memberships in reverse chronological order' do
      expect(assigns(:party_memberships)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:party_memberships)[1].start_date).to eq(DateTime.new(1987, 6, 11))
    end

    it 'renders the parties template' do
      expect(response).to render_template('index')
    end
  end

  describe "GET current" do
    before(:each) do
      get :current, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @party' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
    end

    it 'renders the current_party template' do
      expect(response).to render_template('current')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            parameters: { person_id: '7TX8ySd4' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/people/7TX8ySd4/parties"
          },
          {
            route: 'current',
            parameters: { person_id: '7TX8ySd4' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/people/7TX8ySd4/parties/current"
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
