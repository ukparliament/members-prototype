require 'rails_helper'

RSpec.describe 'people/constituencies', vcr: true do
  context 'header' do
    before do
      assign(:person, double(:person, display_name: 'Test Name'))
      assign(:seat_incumbencies, [])

      render
    end

    it 'will render the correct header' do
      expect(rendered).to match(/Test Name - Current and former constituencies/)
    end
  end

  context '@seat_incumbencies' do
    context 'not empty' do
      before do
        assign(:person, double(:person, display_name: 'Test Name'))
        @seat_incumbencies = [double(:seat_incumbency, start_date: Time.zone.now, end_date: nil, current?: true, constituency: double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE'))]

        render
      end

      it 'will render people/seat_incumbency' do
        expect(response).to render_template(partial: 'people/_seat_incumbency')
      end
    end

    context 'empty' do
      before do
        assign(:person, double(:person, display_name: 'Test Name'))
        assign(:seat_incumbencies, [])
        render
      end

      it 'will not render people/seat_incumbency' do
        expect(response).not_to render_template(partial: 'people/_seat_incumbency')
      end
    end
  end
end
