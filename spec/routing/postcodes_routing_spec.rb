require 'rails_helper'

RSpec.describe 'postcodes', type: :routing do
  describe PostcodesController do
    context 'postcodes' do
      include_examples  'index route', 'postcodes'

      # postcodes#lookup
      include_examples 'top level routes', 'postcodes', 'lookup'

    end

    context 'postcode' do
      # postcodes#show
      include_examples 'nested routes with a postcode', 'postcodes', 'SW1A-2AA', [], 'show'
    end
  end
end
