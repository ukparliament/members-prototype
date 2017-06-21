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
end
