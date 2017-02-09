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

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe "GET show" do
    before(:each) do
      get :show, params: { id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788' }
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
      get :members, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the members template' do
      expect(response).to render_template('members')
    end
  end

  describe "GET current_members" do
    before(:each) do
      get :current_members, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the current_members template' do
      expect(response).to render_template('current_members')
    end
  end

  describe "GET parties" do
    before(:each) do
      get :parties, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788' }
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

    it 'renders the parties template' do
      expect(response).to render_template('parties')
    end
  end

  describe "GET current_parties" do
    before(:each) do
      get :current_parties, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788' }
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

    it 'renders the parties template' do
      expect(response).to render_template('parties')
    end
  end

  describe "GET party" do
    before(:each) do
      get :party, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house and @parties' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
    end

    it 'renders the party template' do
      expect(response).to render_template('party')
    end
  end

  describe "GET members_letters" do
    before(:each) do
      get :members_letters, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', letter: "t" }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the members template' do
      expect(response).to render_template('members')
    end
  end

  describe "GET current_members_letters" do
    before(:each) do
      get :current_members_letters, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', letter: "t" }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the current_members template' do
      expect(response).to render_template('current_members')
    end
  end

  describe "GET party_members" do
    before(:each) do
      get :party_members, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the party_members template' do
      expect(response).to render_template('party_members')
    end
  end

  describe "GET party_members_letters" do
    before(:each) do
      get :party_members_letters, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980', letter: 't' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the party_members template' do
      expect(response).to render_template('party_members')
    end
  end

  describe "GET current_party_members" do
    before(:each) do
      get :current_party_members, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the party_members template' do
      expect(response).to render_template('party_members')
    end
  end

  describe "GET current_party_members_letters" do
    before(:each) do
      get :current_party_members_letters, params: { house_id: 'c2d41b82-d4df-4f50-b0f9-f52b84a6a788', party_id: 'ab77ae5d-7559-4636-ac25-2a23fd961980', letter: 't' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @house, @party and @people' do
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the party_members template' do
      expect(response).to render_template('party_members')
    end
  end
end
