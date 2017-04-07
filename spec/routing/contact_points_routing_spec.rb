require 'rails_helper'

RSpec.describe 'contact points', type: :routing do
  describe 'ContactPointsController' do
    context 'index' do
      it 'GET contact_points#index' do
        expect(get: '/contact-points').to route_to(
          controller: 'contact_points',
          action:     'index'
        )
      end
    end

    context 'show' do
      it 'GET contact_points#show' do
        expect(get: '/contact-points/a11425ca-6a47-4170-80b9-d6e9f3800a52').to route_to(
          controller:       'contact_points',
          action:           'show',
          contact_point_id: 'a11425ca-6a47-4170-80b9-d6e9f3800a52'
        )
      end
    end
  end
end
