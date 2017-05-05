require 'rails_helper'

RSpec.describe 'people/_seat_incumbency', vcr: true do
  context 'links' do
    before do
      seat_incumbency = double(:seat_incumbency,
        start_date:   Time.zone.now - 1.month,
        end_date:     nil,
        constituency: double(:constituency, name: 'Test Constituency', graph_id: 'MtbjxRrE'))

      allow(seat_incumbency).to receive(:current?).and_return(true)
      render partial: 'people/seat_incumbency', locals: { seat_incumbency: seat_incumbency }
    end

    it 'will render link to constituency_path' do
      expect(rendered).to have_link('Test Constituency', href: constituency_path('MtbjxRrE'))
    end
  end

  context 'start date' do
    context 'is nil' do
      before do
        seat_incumbency = double(:seat_incumbency,
          start_date:   Time.zone.now - 1.month,
          end_date:     Time.zone.now - 1.day,
          constituency: double(:constituency, name: 'Test Constituency', graph_id: 'MtbjxRrE'))

        allow(seat_incumbency).to receive(:current?).and_return(true)
        render partial: 'people/seat_incumbency', locals: { seat_incumbency: seat_incumbency }
      end

      it 'will not render start date' do
        expect(rendered).not_to match((Time.zone.now - 1.day).strftime('%-e %b %Y'))
      end
    end

    context 'is not nil' do
      before do
        seat_incumbency = double(:seat_incumbency,
          start_date:   Time.zone.now - 1.month,
          end_date:     Time.zone.now - 1.day,
          constituency: double(:constituency, name: 'Test Constituency', graph_id: 'MtbjxRrE'))

        allow(seat_incumbency).to receive(:current?).and_return(true)
        render partial: 'people/seat_incumbency', locals: { seat_incumbency: seat_incumbency }
      end

      it 'will render the start date' do
        expect(rendered).to match((Time.zone.now - 1.month).strftime('%-e %b %Y'))
      end
    end
  end

  context 'seat_incumbency.current?' do
    context 'not current' do
      before do
        seat_incumbency = double(:seat_incumbency,
          start_date:   Time.zone.now - 1.month,
          end_date:     Time.zone.now - 1.day,
          constituency: double(:constituency, name: 'Test Constituency', graph_id: 'MtbjxRrE'))

        allow(seat_incumbency).to receive(:current?).and_return(false)
        render partial: 'people/seat_incumbency', locals: { seat_incumbency: seat_incumbency }
      end

      it 'will render end date' do
        expect(rendered).to match("to #{(Time.zone.now - 1.day).strftime('%-e %b %Y')}")
      end
    end

    context 'is current' do
      before do
        seat_incumbency = double(:seat_incumbency,
          start_date:   Time.zone.now - 1.month,
          end_date:     nil,
          constituency: double(:constituency, name: 'Test Constituency', graph_id: 'MtbjxRrE'))

        allow(seat_incumbency).to receive(:current?).and_return(true)
        render partial: 'people/seat_incumbency', locals: { seat_incumbency: seat_incumbency }
      end

      it 'will render correct text' do
        expect(rendered).to match(/to present/)
      end
    end
  end
end
