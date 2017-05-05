require 'rails_helper'

RSpec.describe 'people/parties', vcr: true do
  before do
    assign(:person, double(:person, display_name: 'Test Name'))
    assign(:party_memberships, [double(:party_membership,
      start_date: Time.zone.now - 1.month,
      end_date:   nil,
      party:      double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'),
      current?:   true)])
    assign(:letters, 'A')
    controller.params = { letter: 'a' }

    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Test Name - Current and former parties and groups/)
    end
  end

  context 'partials' do
    it 'will render people/_party_membership' do
      expect(response).to render_template(partial: 'people/_party_membership')
    end
  end
end
