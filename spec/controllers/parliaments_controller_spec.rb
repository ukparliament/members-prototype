require 'rails_helper'

RSpec.describe ParliamentsController, vcr: true do
  describe "GET index" do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parliaments' do
      assigns(:parliaments).each do |parliament|
        expect(parliament).to be_a(Grom::Node)
        expect(parliament.type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end
    end

    it 'assigns @parliaments in numeric order' do
      expect(assigns(:parliaments)[0].number).to eq(57)
      expect(assigns(:parliaments)[1].number).to eq(56)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET current' do
    context '@parliament is nil' do
      # updated VCR cassette in order to set @parliament to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :current}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@parliament is not nil' do
      before(:each) do
        get :current
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end

      it 'redirects to parliaments/:parliament_id' do
        expect(response).to redirect_to(parliament_path(assigns(:parliament).graph_id))
      end
    end
  end

  describe 'GET next' do
    context '@parliament is nil' do
      # updated VCR cassette in order to set @parliament to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :next}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@pariament is not nil' do
      before(:each) do
        get :next
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end

      it 'redirects to parliaments/:parliament_id' do
        expect(response).to redirect_to(parliament_path(assigns(:parliament).graph_id))
      end
    end
  end

  describe 'GET previous' do
    context '@parliament is nil' do
      # updated VCR cassette in order to set @parliament to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :previous}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@parliament is not nil' do
      before(:each) do
        get :previous
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end

      it 'redirects to parliaments/:parliament_id' do
        expect(response).to redirect_to(parliament_path(assigns(:parliament).graph_id))
      end
    end
  end

  describe 'GET lookup' do
    it 'is a pending example'
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: { parliament_id: '0FxbTVtr' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parliament' do
      expect(assigns(:parliament)).to be_a(Grom::Node)
      expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe 'GET next_parliament' do
    context '@parliament is nil' do
      # updated VCR cassette in order to set @parliament to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :next_parliament, params: { parliament_id: '0FxbTVtr' }}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@parliament is not nil' do
      before(:each) do
        get :next_parliament, params: { parliament_id: '0FxbTVtr' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end

      it 'redirects to parliaments/:parliament_id' do
        expect(response).to redirect_to(parliament_path(assigns(:parliament).graph_id))
      end
    end
  end

  describe 'GET previous_parliament' do
    context '@parliament is nil' do
      # updated VCR cassette in order to set @parliament to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :previous_parliament, params: { parliament_id: '0FxbTVtr' }}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@parliament is not nil' do
      before(:each) do
        get :previous_parliament, params: { parliament_id: '0FxbTVtr' }
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end

      it 'redirects to parliaments/:parliament_id' do
        expect(response).to redirect_to(parliament_path(assigns(:parliament).graph_id))
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      #TODO this doesn't include lookup yet
      methods = [
          {
            route: 'index',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments"
          },
          {
            route: 'current',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/current"
          },
          {
            route: 'next_parliament',
            parameters: { parliament_id: '0FxbTVtr' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/next"
          },
          {
            route: 'previous',
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/previous"
          },
          {
            route: 'previous_parliament',
            parameters: { parliament_id: '0FxbTVtr' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/previous"
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
    describe 'next' do
      context '@parliament is nil' do
        # updated VCR cassette in order to set @parliament to nil
        it 'should raise ActionController::RoutingError' do
          expect{get :next}.to raise_error(ActionController::RoutingError)
        end
      end

      context '@pariament is not nil' do
        before(:each) do
          headers = { 'Accept' => 'application/rdf+xml' }
          request.headers.merge(headers)
          get :next
        end

        it 'should have a response with http status redirect (302)' do
            expect(response).to have_http_status(302)
        end

        it 'redirects to the data service' do
            expect(response).to redirect_to("#{ENV['PARLIAMENT_BASE_URL']}/parliaments/next")
        end
      end
    end
  end
end
