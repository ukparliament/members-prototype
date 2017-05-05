require 'rails_helper'
include ActionView::Helpers::UrlHelper

RSpec.describe MetaController, vcr: true do
  # render_views

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end

    it 'includes a link to cookie policy' do
      @meta_routes = []
      Rails.application.routes.routes.each do |route|
        path = route.path.spec.to_s

        next unless path.starts_with?('/meta/')

        path = path.sub(/\(.:format\)/, '')
        translation = path.split('/').last
        @meta_routes << { url: path, translation: translation}
      end

      @meta_routes.each do |route|
        expect(response.body).to include(link_to(I18n.t("meta.#{route[:translation].underscore}.title"), route[:url]))
      end
    end
  end

  describe 'GET cookie policy' do
    before(:each) do
      get :cookie_policy
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the cookie_policy template' do
      expect(response).to render_template('cookie_policy')
    end
  end
end
