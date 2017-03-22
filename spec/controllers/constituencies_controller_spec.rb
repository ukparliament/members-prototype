require 'rails_helper'

RSpec.describe ConstituenciesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituencies and @letters' do
      assigns(:constituencies).each do |constituency|
        expect(constituency).to be_a(Grom::Node)
        expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @constituencies in alphabetical order' do
      expect(assigns(:constituencies)[0].name).to eq('Aberavon')
      expect(assigns(:constituencies)[1].name).to eq('Aberavon')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '3274' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @constituency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
    end

    it 'redirects to constituencies/:id' do
      expect(response).to redirect_to(constituency_path('95e3953e-a2bf-4ec0-bc57-5d073661f43a'))
    end
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { constituency_id: 'dd35a30d-ea9b-4274-8a27-f193246191a7' }
    end

    it 'should have a response with a http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituency, @seat_incumbencies and @current_incumbency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')

      assigns(:seat_incumbencies).each do |seat_incumbency|
        expect(seat_incumbency).to be_a(Grom::Node)
        expect(seat_incumbency.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end

      expect(assigns(:current_incumbency)).to be_a(Grom::Node)
      expect(assigns(:current_incumbency).type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      expect(assigns(:current_incumbency).current?).to be(true)
    end

    it 'assigns @seat_incumbencies in reverse chronological order' do
      expect(assigns(:seat_incumbencies)[0].start_date).to eq(DateTime.new(2010, 5, 6))
      expect(assigns(:seat_incumbencies)[1].start_date).to eq(DateTime.new(2005, 5, 5))
    end

    it 'assigns @current_incumbency to be the current incumbency' do
      expect(assigns(:current_incumbency).start_date).to eq(DateTime.new(2015, 5, 7))
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe 'GET current' do
    before(:each) do
      get :current
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituencies and @letters' do
      assigns(:constituencies).each do |constituency|
        expect(constituency).to be_a(Grom::Node)
        expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @constituencies in alphabetical order' do
      expect(assigns(:constituencies)[0].name).to eq('Normanton, Pontefract and Castleford')
      expect(assigns(:constituencies)[1].name).to eq('Stockport')
    end

    it 'renders the current template' do
      expect(response).to render_template('current')
    end
  end

  describe 'GET map' do
    before(:each) do
      get :map, params: { constituency_id: 'f9216185-f3dc-417c-a02e-455faedb2ac2' }
    end

    it 'should have a response with a http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
    end

    it 'renders the map template' do
      expect(response).to render_template('map')
    end
  end

  describe 'GET contact_point' do
    before(:each) do
      get :contact_point, params: { constituency_id: '8d895ffc-c2bf-43d2-b756-95ab3e987919' }
    end

    it 'should have a response with a http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
    end

    it 'renders the contact_point template' do
      expect(response).to render_template('contact_point')
    end
  end

  describe 'GET members' do
    before(:each) do
      get :members, params: { constituency_id: 'f9216185-f3dc-417c-a02e-455faedb2ac2' }
    end

    it 'should have a response with a http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituency and @seat_incumbencies' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')

      assigns(:seat_incumbencies).each do |seat_incumbency|
        expect(seat_incumbency).to be_a(Grom::Node)
        expect(seat_incumbency.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end
    end

    it 'assigns @seat_incumbencies in reverse chronological order' do
      expect(assigns(:seat_incumbencies)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:seat_incumbencies)[1].start_date).to eq(DateTime.new(2010, 5, 6))
    end

    it 'renders the members template' do
      expect(response).to render_template('members')
    end
  end

  describe 'GET current_member' do
    before(:each) do
      get :current_member, params: { constituency_id: 'f9216185-f3dc-417c-a02e-455faedb2ac2' }
    end

    it 'should have a response with a http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituency and @seat_incumbency' do
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')

      expect(assigns(:seat_incumbency)).to be_a(Grom::Node)
      expect(assigns(:seat_incumbency).type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
    end

    it 'renders the current_member template' do
      expect(response).to render_template('current_member')
    end
  end

  describe 'GET letters' do
    before(:each) do
      get :letters, params: { letter: 'a' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituencies and @letters' do
      assigns(:constituencies).each do |constituency|
        expect(constituency).to be_a(Grom::Node)
        expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @constituencies in alphabetical order' do
      expect(assigns(:constituencies)[0].name).to eq('Aberavon')
      expect(assigns(:constituencies)[1].name).to eq('Aberavon')
    end

    it 'renders the letters template' do
      expect(response).to render_template('letters')
    end
  end

  describe 'GET current_letters' do
    before(:each) do
      get :current_letters, params: { letter: 'a' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @constituencies and @letters' do
      assigns(:constituencies).each do |constituency|
        expect(constituency).to be_a(Grom::Node)
        expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @constituencies in alphabetical order' do
      expect(assigns(:constituencies)[0].name).to eq('Aberdeen North')
      expect(assigns(:constituencies)[1].name).to eq('Aldridge-Brownhills')
    end

    it 'renders the current_letters template' do
      expect(response).to render_template('current_letters')
    end
  end

  describe "GET a_to_z" do
    before(:each) do
      get :a_to_z
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z template' do
      expect(response).to render_template('a_to_z')
    end
  end

  describe "GET a_to_z_current" do
    before(:each) do
      get :a_to_z_current
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_current template' do
      expect(response).to render_template('a_to_z_current')
    end
  end

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'hove' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to constituencies/a-z/hove' do
        expect(response).to redirect_to(constituencies_a_z_letter_path(:letter => 'hove'))
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: { letters: 'arfon' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to constituencies/:id' do
        expect(response).to redirect_to(constituency_path('f9216185-f3dc-417c-a02e-455faedb2ac2'))
      end
    end
  end
end
