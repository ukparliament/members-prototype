require 'rails_helper'

RSpec.describe Parliaments::MembersController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index, params: { parliament_id: '0FxbTVtr' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parliament, @people and @letters' do
      expect(assigns(:parliament)).to be_a(Grom::Node)
      expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('personGivenName - 1')
      expect(assigns(:people)[1].given_name).to eq('personGivenName - 1673')
    end

    it 'renders the members template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET letters' do
    before(:each) do
      get :letters, params: { parliament_id: 'GEFMX81E', letter: 'a' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parliament, @people and @letters' do
      expect(assigns(:parliament)).to be_a(Grom::Node)
      expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('personGivenName - 1')
      expect(assigns(:people)[1].given_name).to eq('personGivenName - 10')
    end
  end

  describe 'GET a_to_z' do
    before(:each) do
      get :a_to_z, params: { parliament_id: 'GEFMX81E' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parliament and @letters' do
      expect(assigns(:parliament)).to be_a(Grom::Node)
      expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the members a-z template' do
      expect(response).to render_template('a_to_z')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      # Currently, a_to_z renders the same data as index, so this is reflected in the api request
      methods = [
          {
            route: 'index',
            parameters: { parliament_id: '0FxbTVtr' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/members"
          },
          {
            route: 'a_to_z',
            parameters: { parliament_id: '0FxbTVtr' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/members"
          },
          {
            route: 'letters',
            parameters: { parliament_id: '0FxbTVtr', letter: 'a' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/members/a"
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
