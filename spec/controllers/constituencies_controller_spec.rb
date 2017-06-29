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
        get :show, params: { constituency_id: 'vUPobpVT' }, flash: { postcode: 'E2 0JA' }
      end

      it 'assigns @postcode, @postcode_constituency' do
        expect(assigns(:postcode)).to eq('E2 0JA')

        expect(assigns(:postcode_constituency)).to be_a(Grom::Node)
        expect(assigns(:postcode_constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
      end
    end

    context 'given an invalid postcode' do
      before(:each) do
        get :show, params: { constituency_id: 'vUPobpVT' }, flash: { postcode: 'apple' }
      end

      it 'assigns @postcode and flash[:error]' do
        expect(assigns(:postcode)).to be(nil)
        expect(flash[:error]).to eq("We couldn't find the postcode you entered.")
      end
    end
  end

  describe "POST postcode_lookup" do
    before(:each) do
      post :postcode_lookup, params: { constituency_id: 'vUPobpVT', postcode: 'E2 0JA' }
    end

    it 'assigns flash[:postcode]' do
      expect(flash[:postcode]).to eq('E2 0JA')
    end

    it 'redirects to people/:id' do
      expect(response).to redirect_to(constituency_path('vUPobpVT'))
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
        expect(assigns(:constituencies)[0].name).to eq('constituencyGroupName - 1')
        expect(assigns(:constituencies)[1].name).to eq('constituencyGroupName - 10')
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

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(200)
      end

      it 'assigns @constituencies and @letters' do
        assigns(:constituencies).each do |constituency|
          expect(constituency).to be_a(Grom::Node)
          expect(constituency.type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'renders the lookup_by_letters template' do
        expect(response).to render_template('lookup_by_letters')
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
        expect(response).to redirect_to(constituency_path('HWhM7sev'))
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      METHODS = [
          {
            route: 'index',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies"
          },
          {
            route: 'lookup',
            parameters: { source: 'mnisId', id: '3274' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/lookup/mnisId/3274"
          },
          {
            route: 'show',
            parameters: { constituency_id: 'vUPobpVT' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/vUPobpVT"
          },
          {
            route: 'lookup_by_letters',
            parameters: { letters: 'epping' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/partial/epping"
          },
          {
            route: 'a_to_z_current',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/current/a_z_letters"
          },
          {
            route: 'current',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/current"
          },
          {
            route: 'map',
            parameters: { constituency_id: 'vUPobpVT' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/vUPobpVT"
          },
          {
            route: 'letters',
            parameters: { letter: 'p' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/p"
          },
          {
            route: 'current_letters',
            parameters: { letter: 'p' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/current/p"
          },
          {
            route: 'a_to_z',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/a_z_letters"
          },
        ]

      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'should have a response with http status redirect (302)' do
        METHODS.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to have_http_status(302)
        end
      end

      it 'redirects to the data service' do
        METHODS.each do |method|
          if method.include?(:parameters)
            get method[:route].to_sym, params: method[:parameters]
          else
            get method[:route].to_sym
          end
          expect(response).to redirect_to(method[:data_url])
        end
      end

    end

    context 'an unavailable data format is requested' do
      before(:each) do
        headers = { 'Accept' => 'application/n-quads' }
        request.headers.merge(headers)
      end

      it 'should raise ActionController::UnknownFormat error' do
        expect{ get :index }.to raise_error(ActionController::UnknownFormat)
      end
    end
  end

end
