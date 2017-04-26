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
      expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 1')
      expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 10')
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
      expect(response).to redirect_to(constituency_path('beRgFrSo'))
    end
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { constituency_id: 'vUPobpVT' }
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

    context 'given a valid postcode' do
      before(:each) do
        get :show, params: { constituency_id: 'vUPobpVT', postcode: 'E2 0JA' }
      end

      it 'assigns @postcode, @postcode_constituency' do
        expect(assigns(:postcode)).to eq('E2 0JA')

        expect(assigns(:postcode_constituency)).to be_a(Grom::Node)
        expect(assigns(:postcode_constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end
    end

    context 'given an invalid postcode' do
      before(:each) do
        get :show, params: { constituency_id: 'vUPobpVT', postcode: 'apple' }
      end

      it 'assigns @postcode and flash[:error]' do
        expect(assigns(:postcode)).to be(nil)
        expect(flash[:error]).to eq('No constituency found for the postcode entered.')
      end
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
      expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 1')
      expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 10')
    end

    it 'renders the current template' do
      expect(response).to render_template('current')
    end
  end

  describe 'GET map' do
    before(:each) do
      get :map, params: { constituency_id: 'vUPobpVT' }
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
      get :contact_point, params: { constituency_id: 'MtbjxRrE' }
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
      get :members, params: { constituency_id: 'vTNSMo38' }
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
    end

    it 'assigns @current_incumbency to be the current incumbency' do
      expect(assigns(:current_incumbency).start_date).to eq(DateTime.new(2015, 5, 7))
    end

    it 'renders the members template' do
      expect(response).to render_template('members')
    end
  end

  describe 'GET current_member' do
    before(:each) do
      get :current_member, params: { constituency_id: 'vTNSMo38' }
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
    context 'returns a response' do
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
        expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 1')
        expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 10')
      end

      it 'renders the letters template' do
        expect(response).to render_template('letters')
      end
    end

    context 'does not return a response ' do
      before(:each) do
        get :letters, params: { letter: 'z' }
      end

      it 'returns a 200 response ' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @constituencies as an empty array' do
        expect(controller.instance_variable_get(:@constituencies)).to be_empty
      end
    end
  end

  describe 'GET current_letters' do
    context 'returns a response ' do
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
        expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 123')
        expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 141')
      end

      it 'renders the current_letters template' do
        expect(response).to render_template('current_letters')
      end
    end

    context 'does not return a response ' do
      before(:each) do
        get :letters, params: { letter: 'z' }
      end

      it 'returns a 200 response ' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @constituencies as an empty array' do
        expect(controller.instance_variable_get(:@constituencies)).to be_empty
      end
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
        expect(response).to redirect_to(constituency_path('vTNSMo38'))
      end
    end
  end
end
