require 'rails_helper'

RSpec.describe HousesController, vcr: true do

  describe "GET index" do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @houses' do
      assigns(:houses).each do |house|
        expect(house).to be_a(Grom::Node)
        expect(house.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    it 'assigns @houses in alphabetical order' do
      expect(assigns(:houses)[0].name).to eq('House of Commons')
      expect(assigns(:houses)[1].name).to eq('House of Lords')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '1' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'redirects to houses/:id' do
      expect(response).to redirect_to(house_path('9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703'))
    end
  end

  describe "GET show" do
    before(:each) do
      get :show, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe "GET members" do
    before(:each) do
      get :members, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @people and @letters' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the members template' do
      expect(response).to render_template('members')
    end
  end

  describe "GET current_members" do
    before(:each) do
      get :current_members, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @people and @letters' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the current_members template' do
      expect(response).to render_template('current_members')
    end
  end

  describe "GET parties" do
    before(:each) do
      get :parties, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house and @parties' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    it 'assigns @parties in alphabetical order' do
      expect(assigns(:parties)[0].name).to eq('Alliance')
      expect(assigns(:parties)[1].name).to eq('Anti H Block')
    end

    it 'renders the parties template' do
      expect(response).to render_template('parties')
    end
  end

  describe "GET current_parties" do
    before(:each) do
      get :current_parties, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house and @parties' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    it 'assigns @parties in member_count order' do
      expect(assigns(:parties)[0].name).to eq('Conservative')
      expect(assigns(:parties)[1].name).to eq('Labour')
    end

    it 'renders the current_parties template' do
      expect(response).to render_template('current_parties')
    end
  end

  describe "GET party" do
    context 'both house and party have a valid id' do
      before(:each) do
        get :party, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52', party_id: 'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @house and @party' do
        expect(assigns(:house)).to be_a(Grom::Node)
        expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
        expect(assigns(:party)).to be_a(Grom::Node)
        expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      end

      it 'renders the party template' do
        expect(response).to render_template('party')
      end
    end

    context 'party id is invalid' do
      it 'raises an error if @party is nil' do
        house_id = '4b77dd58-f6ba-4121-b521-c8ad70465f52'
        party_id = '123'

        expect{ get :party, params: { house_id: house_id, party_id: party_id } }.to raise_error(ActionController::RoutingError, 'Invalid party id')
      end
    end
  end

  describe "GET members_letters" do
    before(:each) do
      get :members_letters, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52', letter: 'a' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @people and @letters' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the members_letters template' do
      expect(response).to render_template('members_letters')
    end
  end

  describe "GET current_members_letters" do
    before(:each) do
      get :current_members_letters, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52', letter: 'a' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @people and @letters' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the current_members_letters template' do
      expect(response).to render_template('current_members_letters')
    end
  end

  describe "GET party_members" do
    before(:each) do
      get :party_members, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party, @letters and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the party_members template' do
      expect(response).to render_template('party_members')
    end
  end

  describe "GET party_members_letters" do
    before(:each) do
      get :party_members_letters, params: {house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980', letter: 't'}
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party, @letters and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the party_members_letters template' do
      expect(response).to render_template('party_members_letters')
    end
  end

  describe "GET current_party_members" do
    before(:each) do
      get :current_party_members, params: {house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980'}
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party, @letters and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the current_party_members template' do
      expect(response).to render_template('current_party_members')
    end
  end

  describe "GET current_party_members_letters" do
    before(:each) do
      get :current_party_members_letters, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980', letter: 't' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party, @letters and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the current_party_members_letters template' do
      expect(response).to render_template('current_party_members_letters')
    end
  end

  describe "GET a_to_z_members" do
    before(:each) do
      get :a_to_z_members, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_members template' do
      expect(response).to render_template('a_to_z_members')
    end
  end

  describe "GET a_to_z_current_members" do
    before(:each) do
      get :a_to_z_current_members, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_current_members template' do
      expect(response).to render_template('a_to_z_current_members')
    end
  end

  describe "GET a_to_z_party_members" do
    before(:each) do
      get :a_to_z_party_members, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52', party_id: 'c5858995-6d25-4eb5-b92e-fba3fbd8ba47' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_party_members template' do
      expect(response).to render_template('a_to_z_party_members')
    end
  end

  describe "GET a_to_z_current_party_members" do
    before(:each) do
      get :a_to_z_current_party_members, params: { house_id: '4b77dd58-f6ba-4121-b521-c8ad70465f52', party_id: 'c5858995-6d25-4eb5-b92e-fba3fbd8ba47' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_current_party_members template' do
      expect(response).to render_template('a_to_z_current_party_members')
    end
  end

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: {letters: 'house'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to index' do
        expect(response).to redirect_to(houses_path)
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: {letters: 'commons'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to houses/:id' do
        expect(response).to redirect_to(house_path('c2d41b82-d4df-4f50-b0f9-f52b84a6a788'))
      end
    end
  end
end
