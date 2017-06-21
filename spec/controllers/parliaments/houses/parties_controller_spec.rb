require 'rails_helper'

RSpec.describe Parliaments::Houses::PartiesController, vcr: true do

    describe 'GET index' do
      before(:each) do
        get :index, params: { parliament_id: '0FxbTVtr', house_id: 'cqIATgUK' }
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

      context '@house' do
        it 'assigns @house' do
          expect(assigns(:house)).to be_a(Grom::Node)
          expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
        end
      end

      context '@parties' do
        it 'assigns @parties' do
          assigns(:parties).each do |person|
            expect(person).to be_a(Grom::Node)
            expect(person.type).to eq('http://id.ukpds.org/schema/Party')
          end
        end

        it 'assigns @parties in alphabetical order' do
          expect(assigns(:parties)[0].name).to eq('partyName - 1')
          expect(assigns(:parties)[1].name).to eq('partyName - 10')
        end
      end

      it 'renders the house template' do
        expect(response).to render_template('index')
      end
    end

    describe 'GET show' do
      context '@party is nil' do
        # updated VCR cassette in order to set @party to nil
        it 'should raise ActionController::RoutingError' do
          expect{get :show, params: { parliament_id: '0FxbTVtr', house_id: 'cqIATgUK', party_id: 'P6LNyUn4' }}.to raise_error(ActionController::RoutingError)
        end
      end

      context '@party is not nil' do
        before(:each) do
          get :show, params: { parliament_id: '0FxbTVtr', house_id: 'cqIATgUK', party_id: 'P6LNyUn4' }
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

        context '@house' do
          it 'assigns @house' do
            expect(assigns(:house)).to be_a(Grom::Node)
            expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
          end
        end

        context '@party' do
          it 'assigns @party' do
            expect(assigns(:party)).to be_a(Grom::Node)
            expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
          end
        end

        it 'renders the house template' do
          expect(response).to render_template('show')
        end
      end
    end

    describe '#data_check' do
      context 'an available data format is requested' do
        methods = [
            {
              route: 'index',
              parameters: { parliament_id: '0FxbTVtr', house_id: 'cqIATgUK' },
              data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/houses/cqIATgUK/parties"
            },
            {
              route: 'show',
              parameters: { parliament_id: '0FxbTVtr', house_id: 'cqIATgUK', party_id: 'P6LNyUn4' },
              data_url: "#{ENV['PARLIAMENT_BASE_URL']}/parliaments/0FxbTVtr/houses/cqIATgUK/parties/P6LNyUn4"
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
