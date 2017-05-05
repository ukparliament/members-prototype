require 'rails_helper'

RSpec.describe 'people/houses', vcr: true do
  before do
    assign(:person, double(:person, display_name: 'Test Name'))
  end

  context 'header' do
    before do
      assign(:incumbencies, [])
      render
    end

    it 'will render the correct header' do
      expect(rendered).to match(/Test Name - Current and former houses/)
    end
  end

  context '@incumbencies' do
    context 'empty' do
      before do
        assign(:incumbencies, [])
        render
      end

      it 'will not render partial' do
        expect(response).not_to render_template(partial: 'people/_incumbency')
      end
    end

    context 'not empty' do
      before do
        assign(:incumbencies, [double(:incumbency,
          start_date: Time.zone.now - 1.month,
          end_date:   nil,
          house:      double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'),
          seat:       double(:seat, house: double(:house, name: 'House of Lords', graph_id: 'm1EgVTLj')),
          current?:   true)])
        render
      end

      it 'will render partial' do
        expect(response).to render_template(partial: 'people/_incumbency')
      end
    end
  end
end
