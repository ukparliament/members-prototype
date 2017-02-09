require 'rails_helper'
require 'pry'

RSpec.describe PartiesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parties' do
      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET current' do
    before(:each) do
      get :current
    end

    it 'should return a Parliament::Response object' do
      expect(assigns(:parties)).to be_a(Parliament::Response)
    end

    it 'should return the current number of parties' do
      expect(assigns(:parties).size).to eq(13)
    end

    it 'renders the current template' do
      expect(response).to render_template('current')
    end
  end

  describe 'GET show' do
    context 'for a valid id' do
      before(:each) do
        get :show, params: { id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427' }
      end

      it 'response should return ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return a Grom Node object' do
        expect(assigns(:party)).to be_a(Grom::Node)
      end

      it 'assigns @party and checks that the partyName is contained within it' do
        expect(assigns(:party).partyName).to eq('Labour')
      end

      after(:all) do
        puts 'Test for valid id finished'
      end
    end

    context 'for an invalid id' do
      it 'passes an invalid id to the show page' do
        expect { get :show, params: { id: 'FAKE-ID' } }.to raise_error(ActionController::RoutingError, 'Not Found')
      end

      after(:all) do
        puts 'Test for invalid id finished'
      end
    end
  end

  describe 'GET members' do
    context 'for a specific party' do
      before(:each) do
        get :members, params: { party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427' }
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'should return an Array' do
        expect(assigns(:people)).to be_an_instance_of(Array)
      end

      it 'passes an invalid party id to the show page' do
        expect { get :members, params: { party_id: 'FAKE-PARTY-ID' } }.to raise_error(ActionController::RoutingError, 'Not Found')
      end
    end
  end

  describe 'GET current members' do
    context 'for a specific party' do
      before(:each) do
        get :current_members, params: { party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427' }
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'should return an Array' do
        expect(assigns(:people)).to be_an_instance_of(Array)
      end

      it 'passes an invalid party id to the show page' do
        expect { get :current_members, params: { party_id: 'FAKE-PARTY-ID' } }.to raise_error(ActionController::RoutingError, 'Not Found')
      end
    end
  end

  describe 'GET letters' do
    context 'parties for a specific letter' do
      before(:each) do
        get :letters, params: { letter: 'h' }
      end

      it 'should return a Grom Node object as a party' do
        expect(assigns(:party)).to be_a(Grom::Node)
      end

      it 'assigns @party and checks that the correct partyname is returned' do
        expect(assigns(:party).partyName).to eq('Humanity')
      end

      it 'passes an invalid letter to the letters page' do
        expect { get :letters, params: { letter: '1' } }.to raise_error(ActionController::UrlGenerationError)
      end
    end
  end

  describe 'GET members_letters' do
    context 'members for a specific party with a specific letter' do
      before(:each) do
        get :members_letters, params: { party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427', letter: 'a' }
      end

      it 'assigns party and checks that the type is Party' do
        expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      end

      it 'should return a Grom Node object as a party' do
        expect(assigns(:party)).to be_a(Grom::Node)
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'passes an invalid letter and party id to the members_letters page' do
        expect { get :members_letters, params: { party_id: 'FAKE-PARTY-ID', letter: '1' } }.to raise_error(ActionController::UrlGenerationError)
      end
    end
  end

  describe 'GET current_members_letters' do
    context 'current members for a specific party with a specific letter' do
      before(:each) do
        get :current_members_letters, params: { party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427', letter: 'c' }
      end

      it 'assigns party and checks that the type is Party' do
        expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      end

      it 'should return a Grom Node object as a party' do
        expect(assigns(:party)).to be_a(Grom::Node)
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'passes an invalid letter and party id to the members_letters page' do
        expect { get :members_letters, params: { party_id: 'FAKE-PARTY-ID', letter: '1' } }.to raise_error(ActionController::UrlGenerationError)
      end
    end
  end
end
