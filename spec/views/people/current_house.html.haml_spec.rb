require 'rails_helper'

RSpec.describe 'people/current_house', vcr: true do
  before do
    assign(:person, double(:person, display_name: 'Test Name'))
  end

  context 'header' do
    before do
      assign(:house, nil)
      render
    end

    it 'will render the correct header' do
      expect(rendered).to match(/Test Name - Current house/)
    end
  end

  context '@house' do
    context 'nil' do
      before do
        assign(:house, nil)
        render
      end

      it 'will not render link to house_path' do
        expect(rendered).not_to have_link('House of Commons', href: house_path('KL2k1BGP'))
      end
    end

    context 'not nil' do
      before do
        assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP', seat_incumbencies: [double(:seat_incumbency, start_date: nil)], house_incumbencies: [double(:house_incumbency, start_date: nil)]))
        render
      end

      it 'will render link to house_path' do
        expect(rendered).to have_link('House of Commons', href: house_path('KL2k1BGP'))
      end

      context 'house seat incumbency start date' do
        context 'nil' do
          before do
            assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP', seat_incumbencies: [double(:seat_incumbency, start_date: nil)], house_incumbencies: [double(:house_incumbency, start_date: nil)]))
            render
          end

          it 'will not render link description' do
            expect(rendered).not_to match("#{(Time.zone.now - 2.month).strftime('%-e %b %Y')} to present")
          end
        end

        context 'not nil' do
          before do
            assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP', seat_incumbencies: [double(:seat_incumbency, start_date: Time.zone.now - 1.month)], house_incumbencies: [double(:house_incumbency, start_date: Time.zone.now - 2.month)]))
            render
          end

          it 'will render link description' do
            expect(rendered).to match("#{(Time.zone.now - 2.month).strftime('%-e %b %Y')} to present")
          end
        end
      end
    end
  end
end
