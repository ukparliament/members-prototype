require 'rails_helper'

RSpec.describe 'people/current_constituency', vcr: true do
  before do
    assign(:person, double(:person, display_name: 'Test Name'))
  end

  context 'header' do
    before do
      assign(:constituency, nil)
      render
    end

    it 'will render the correct header' do
      expect(rendered).to match(/Test Name - Current constituency/)
    end
  end

  context '@constituency' do
    context 'nil' do
      before do
        assign(:constituency, nil)
        render
      end

      it 'will not render link to party_path' do
        expect(rendered).not_to have_link('Aberavon', href: party_path('MtbjxRrE'))
      end
    end

    context 'not nil' do
      before do
        assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', seat_incumbencies: [double(:seat_incumbency, start_date: nil)]))
        render
      end

      it 'will render link to party_path' do
        expect(rendered).to have_link('Aberavon', href: party_path('MtbjxRrE'))
      end

      context 'constituency seat incumbency start date' do
        context 'nil' do
          before do
            assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', seat_incumbencies: [double(:seat_incumbency, start_date: nil)]))
            render
          end

          it 'will not render link description' do
            expect(rendered).not_to match("#{(Time.zone.now - 1.month).strftime('%-e %b %Y')} to present")
          end
        end

        context 'not nil' do
          before do
            assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', seat_incumbencies: [double(:seat_incumbency, start_date: Time.zone.now - 1.month)]))
            render
          end

          it 'will render link description' do
            expect(rendered).to match("#{(Time.zone.now - 1.month).strftime('%-e %b %Y')} to present")
          end
        end
      end
    end
  end
end
