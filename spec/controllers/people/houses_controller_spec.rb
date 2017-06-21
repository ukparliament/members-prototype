require 'rails_helper'

RSpec.describe People::HousesController, vcr: true do

  describe "GET index" do
    before(:each) do
      get :index, params: { person_id: '7TX8ySd4' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @incumbencies' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:incumbencies).each do |incumbency|
        expect(incumbency).to be_a(Grom::Node)
        expect(incumbency.type).to eq('http://id.ukpds.org/schema/Incumbency')
      end
    end

    it 'assigns @incumbencies in reverse chronological order' do
      expect(assigns(:incumbencies)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:incumbencies)[1].start_date).to eq(DateTime.new(2010, 5, 6))
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

    it 'assigns @person and @house' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
    end

    it 'renders the current_house template' do
      expect(response).to render_template('current')
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            parameters: { person_id: '7TX8ySd4' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/people/7TX8ySd4/houses"
          },
          {
            route: 'current',
            parameters: { person_id: '7TX8ySd4' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/people/7TX8ySd4/houses/current"
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
