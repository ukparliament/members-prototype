require 'rails_helper'

RSpec.describe PeopleController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe "GET show" do
    before(:each) do
      get :show, params: { person_id: '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe "GET members" do
    before(:each) do
      get :members
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people' do
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
      get :current_members
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the current_members template' do
      expect(response).to render_template('current_members')
    end
  end

  describe "GET contact_points" do
    before(:each) do
      get :contact_points, params: { person_id: '08a3dfac-652a-44d6-8a43-00bb13c60e47' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @contact_points' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:contact_points).each do |contact_point|
        expect(contact_point).to be_a(Grom::Node)
        expect(contact_point.type).to eq('http://id.ukpds.org/schema/ContactPoint')
      end
    end

    it 'renders the contact_points template' do
      expect(response).to render_template('contact_points')
    end
  end

  describe "GET parties" do
    before(:each) do
      get :parties, params: { person_id: '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @parties' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    it 'renders the parties template' do
      expect(response).to render_template('parties')
    end
  end

  describe "GET current_party" do
    before(:each) do
      get :current_party, params: { person_id: '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
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
      expect(response).to render_template('current_party')
    end
  end

  describe "GET constituencies" do
    before(:each) do
      get :constituencies, params: { person_id: '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @constituencies' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:constituencies).each do |constituency|
        expect(constituency).to be_a(Grom::Node)
        expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end
    end

    it 'renders the parties template' do
      expect(response).to render_template('constituencies')
    end
  end

  describe "GET current_constituency" do
    before(:each) do
      get :current_constituency, params: { person_id: 'ff75cd0c-1a8b-49ab-8292-f00d153588e5' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @constituency' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
    end

    it 'renders the current_constituency template' do
      expect(response).to render_template('current_constituency')
    end
  end

  describe "GET houses" do
    before(:each) do
      get :houses, params: { person_id: 'ff75cd0c-1a8b-49ab-8292-f00d153588e5' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @houses' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:houses).each do |house|
        expect(house).to be_a(Grom::Node)
        expect(house.type).to eq('http://id.ukpds.org/schema/House')
      end
    end

    it 'renders the parties template' do
      expect(response).to render_template('houses')
    end
  end

  describe "GET current_house" do
    before(:each) do
      get :current_house, params: { person_id: 'ff75cd0c-1a8b-49ab-8292-f00d153588e5' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @house' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
    end

    it 'renders the current_house template' do
      expect(response).to render_template('current_house')
    end
  end

  describe 'GET letters' do
    before(:each) do
      get :letters, params: { letter: 't' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the letters template' do
      expect(response).to render_template('letters')
    end
  end

  describe "GET members_letters" do
    before(:each) do
      get :members_letters, params: { letter: "t" }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the members_letters template' do
      expect(response).to render_template('members_letters')
    end
  end

  describe "GET current_members_letters" do
    before(:each) do
      get :current_members_letters, params: { letter: "t" }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'renders the current_members_letters template' do
      expect(response).to render_template('current_members_letters')
    end
  end
end
