require 'rails_helper'

RSpec.describe HomeController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render index page' do
      expect(response).to render_template('index')
    end
  end
  describe 'GET mps' do
    before(:each) do
      get :mps
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'should render mps page' do
      expect(response).to render_template('mps')
    end

    it 'assigns @parliaments, @parties and @speaker' do

      assigns(:parliaments).each do |parliament|
        expect(parliament).to be_a(Grom::Node)
        expect(parliament.type).to eq('http://id.ukpds.org/schema/ParliamentPeriod')
      end

      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end

      assigns(:speaker).each do |speaker|
        expect(speaker).to be_a(Grom::Node)
        expect(speaker.type).to eq('http://id.ukpds.org/schema/Person')
      end

    end

  end

  describe '#data_check' do
    context 'no data available' do
      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
      end

      it 'GET index should raise an error' do
        expect{get :index}.to raise_error(StandardError, 'Data URL does not exist')
      end
    end

    context 'data available' do
      before(:each) do
        headers = { 'Accept' => 'application/rdf+xml' }
        request.headers.merge(headers)
        get :mps
      end

      it 'GET mps should have a response with http status redirect (302)' do
        expect(response).to redirect_to("#{ENV['PARLIAMENT_BASE_URL']}/people/mps")
      end

      it 'GET mps redirects to the data service' do
        expect(response).to have_http_status(302)
      end
    end
  end
end
