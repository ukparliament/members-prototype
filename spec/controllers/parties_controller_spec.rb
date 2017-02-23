require 'rails_helper'

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

  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '96' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'redirects to parties/:id' do
      expect(response).to redirect_to(party_path('9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703'))
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
    context 'for a valid party id' do
      before(:each) do
        get :show, params: {party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427'}
      end

      it 'response should return ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'should return a Grom Node object' do
        expect(assigns(:party)).to be_a(Grom::Node)
      end

      it 'assigns @party and checks that the partyName is contained within it' do
        expect(assigns(:party).name).to eq('Labour')
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end
    end
  end

  describe 'GET members' do
    context 'for a specific party' do
      before(:each) do
        get :members, params: {party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427'}
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'should return a Parliament Response' do
        expect(assigns(:people)).to be_a(Parliament::Response)
      end

      it 'renders the members template' do
        expect(response).to render_template('members')
      end
    end
  end

  describe 'GET current members' do
    context 'for a specific party' do
      before(:each) do
        get :current_members, params: {party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427'}
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'should return a Parliament Response' do
        expect(assigns(:people)).to be_a(Parliament::Response)
      end

      it 'renders the current_members template' do
        expect(response).to render_template('current_members')
      end
    end
  end

  describe 'GET letters' do
    context 'parties for a specific letter' do
      before(:each) do
        get :letters, params: {letter: 'h'}
      end

      it 'assigns @parties' do
        assigns(:parties).each do |party|
          expect(party).to be_a(Grom::Node)
          expect(party.type).to eq('http://id.ukpds.org/schema/Party')
        end
      end
    end
  end

  describe 'GET members_letters' do
    context 'members for a specific party with a specific letter' do
      before(:each) do
        get :members_letters, params: {party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427', letter: 'a'}
      end

      it 'assigns party and checks that the type is Party' do
        expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'renders the members_letters template' do
        expect(response).to render_template('members_letters')
      end
    end
  end

  describe 'GET current_members_letters' do
    context 'current members for a specific party with a specific letter' do
      before(:each) do
        get :current_members_letters, params: {party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427', letter: 'c'}
      end

      it 'assigns party and checks that the type is Party' do
        expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      end

      it 'assigns @people and checks that the type is Person' do
        assigns(:people).each do |person|
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end
      end

      it 'renders the current_members_letters template' do
        expect(response).to render_template('current_members_letters')
      end
    end
  end

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: {letters: 'labour'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to parties/a-z/labour' do
        expect(response).to redirect_to(parties_a_z_letter_path(letter: 'labour'))
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: {letters: 'guildford'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to people/:id' do
        expect(response).to redirect_to(party_path('cd1f1624-a361-4e1f-92b7-9abf5378d953'))
      end
    end
  end
end
