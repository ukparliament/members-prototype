require 'rails_helper'

RSpec.describe Parliaments::PartiesController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index, params: { parliament_id: 'GEFMX81E' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    context '@parliament' do
      it 'assigns @parliament' do
        expect(assigns(:parliament)).to be_a(Grom::Node)
        expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end
    end

    context '@parties' do
      it 'assigns @parties' do
        assigns(:parties).each do |party|
          expect(party).to be_a(Grom::Node)
          expect(party.type).to eq('http://id.ukpds.org/schema/Party')
        end
      end

      it 'assigns @parties in member count then name order' do
        expect(assigns(:parties)[0].name).to eq('partyName - 11')
        expect(assigns(:parties)[0].member_count).to eq(333)
        expect(assigns(:parties)[1].name).to eq('partyName - 1')
        expect(assigns(:parties)[1].member_count).to eq(240)
        expect(assigns(:parties)[10].name).to eq('partyName - 3')
        expect(assigns(:parties)[10].member_count).to eq(1)
        expect(assigns(:parties)[11].name).to eq('partyName - 4')
        expect(assigns(:parties)[11].member_count).to eq(1)
        expect(assigns(:parties)[12].name).to eq('partyName - 7')
        expect(assigns(:parties)[12].member_count).to eq(1)
      end
    end

    it 'renders the parties template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    context '@party is nil' do
      # updated VCR cassette in order to set @party to nil
      it 'should raise ActionController::RoutingError' do
        expect{get :show, params: { parliament_id: '0FxbTVtr', party_id: 'P6LNyUn4' }}.to raise_error(ActionController::RoutingError)
      end
    end

    context '@party is not nil' do
      before(:each) do
        get :show, params: { parliament_id: '0FxbTVtr', party_id: 'P6LNyUn4' }
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      context '@parliament' do
        it 'assigns @parliament' do
          expect(assigns(:parliament)).to be_a(Grom::Node)
          expect(assigns(:parliament).type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
        end
      end

      context '@party' do
        it 'assigns @party' do
          expect(assigns(:party)).to be_a(Grom::Node)
          expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
        end
      end

      it 'renders the party template' do
        expect(response).to render_template('show')
      end
    end
  end

  describe '#data_check' do
    context 'an available data format is requested' do
      methods = [
          {
            route: 'index',
            parameters: { parliament_id: '0FxbTVtr' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/parties"
          },
          {
            route: 'show',
            parameters: { parliament_id: '0FxbTVtr', party_id: 'P6LNyUn4' },
            data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/parties/P6LNyUn4"
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
