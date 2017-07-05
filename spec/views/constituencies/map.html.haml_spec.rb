require 'rails_helper'

RSpec.describe 'constituencies/map', vcr: true do
  context '@constituency' do
    it 'will render the constituency name' do
      assign(:constituency, double(:constituency, name: 'Aberdeen Central', area: double(:area, polygon: '-3.81201849979 51.58102958827')))
      render
      expect(rendered).to match(/Aberdeen Central/)
    end

    context '@constituency.area' do
      context '@constituency.area is nil' do
        before do
          assign(:constituency, double(:constituency, name: 'Aberdeen Central', area: nil))
          render
        end

        it 'will not render polygon' do
          expect(rendered).not_to match(/-3.81201849979 51.58102958827/)
        end
      end
    end
  end
end
