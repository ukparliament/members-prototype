require 'rails_helper'

RSpec.describe 'constituencies/_constituency', vcr: true do
  context 'constituency?' do

    context 'not current' do
      before do
        assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', start_date: Time.zone.now - 1.month, end_date: nil, current?: false))
        assign(:seat_incumbencies, [double(:seat_incumbencies, start_date: Time.zone.now - 1.month, end_date: nil, current?: true)])
        render
      end

      it 'will render former name' do
        expect(rendered).to match(/Constituency/)
      end
    end
  end

  context 'constituency start date' do
    before do
      assign(:seat_incumbencies, [double(:seat_incumbencies, start_date: Time.zone.now - 1.month, end_date: nil, current?: true)])
    end

    context 'is nil' do
      before do
        assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', start_date: nil, end_date: nil, current?: true))
        render
      end

      it 'will not render start date' do
        expect(rendered).not_to match("from #{(Time.zone.now - 1.month).strftime('%-e %b %Y')}")
      end
    end

    context 'is not nil' do
      before do
        assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', start_date: Time.zone.now - 1.month, end_date: nil, current?: false))
        render
      end

      it 'will render start date' do
        expect(rendered).to match("from #{(Time.zone.now - 1.month).strftime('%-e %b %Y')}")
      end
    end
  end

  context 'constituency end date' do
    before do
      assign(:seat_incumbencies, [double(:seat_incumbencies, start_date: Time.zone.now - 1.month, end_date: nil, current?: true)])
    end

    context 'is not nil' do
      before do
        assign(:constituency, double(:constituency,
          name:       'Aberavon',
          graph_id:   'MtbjxRrE',
          start_date: Time.zone.now - 1.month,
          end_date:   Time.zone.now - 1.day,
          current?:   false))

        render
      end

      it 'will render the end date' do
        expect(rendered).to match("to #{(Time.zone.now - 1.day).strftime('%-e %b %Y')}")
      end
    end
  end

  context 'current incumbency' do
    before do
      assign(:constituency, double(:constituency,
        name:       'Aberavon',
        graph_id:   'MtbjxRrE',
        start_date: Time.now - 1.month,
        end_date:   Time.now - 1.day,
        current?:   true))
      assign(:seat_incumbencies, [double(:seat_incumbencies, start_date: Time.zone.now - 1.month, end_date: nil, current?: true)])
    end

    context 'is nil' do
      it 'will not render current MP' do
        expect(rendered).not_to match(/Current MP/)
      end
    end

    context 'is not nil' do
      before do
        assign(:current_incumbency, double(:current_incumbency, date_range: "#{Time.zone.now} - #{2.month}", start_date: Time.zone.now - 2.month, member: double(:member, display_name: 'Test Display Name', graph_id: '7TX8ySd4')))
        render
      end

      it 'will render current MP' do
        expect(rendered).to match(/MP/)
        expect(rendered).to match(/Test Display Name/)
      end

      context '@current_incumbency.start_date.nil?' do
        context 'is nil' do
          before do
            assign(:current_incumbency, double(:current_incumbency, date_range: "[Date unavailable]", start_date: nil, member: double(:member, display_name: 'Test Display Name', graph_id: '7TX8ySd4')))
            render
          end

          it 'will not render current incumbency start date' do
            expect(rendered).not_to match("#{(Time.zone.now - 1.month).strftime('%-e %b %Y')} to present")
          end
        end

        context 'is not nil' do
          before do
            assign(:current_incumbency, double(:current_incumbency, date_range: "#{(Time.zone.now - 1.month).strftime('%-e %b %Y')} to present", member: double(:member, display_name: 'Test Display Name', graph_id: '7TX8ySd4')))
            render
          end
        end
      end
    end
  end

  context 'number of seat incumbencies' do
    before do
      assign(:constituency, double(:constituency,
        name:       'Aberavon',
        graph_id:   'MtbjxRrE',
        start_date: Time.now - 1.month,
        end_date:   Time.now - 1.day,
        current?:   true))

      assign(:current_incumbency, double(:current_incumbency, date_range: '[Date unavailable]', start_date: nil, member: double(:member, display_name: 'Test Display Name', graph_id: '7TX8ySd4')))
    end

    context 'is not greater than 0' do
      it 'will not render seat incumencies' do
        assign(:seat_incumbencies, [])
        render
        expect(rendered).not_to match(/Former MPs/)
      end
    end
  end

  context 'constituency is not empty' do
    before do
      assign(:seat_incumbencies, [double(:seat_incumbencies, start_date: Time.zone.now - 1.month, end_date: nil, current?: true)])
      assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: false, start_date: Time.zone.now - 1.month, end_date: Time.now - 1.day))
      render
    end

    it 'will list constituency' do
      expect(rendered).to match(/Constituency/)
      expect(rendered).to match("from #{(Time.zone.now - 1.month).strftime('%-e %b %Y')}")
      expect(rendered).to match("to #{(Time.now - 1.day).strftime('%-e %b %Y')}")
    end
  end

  context 'current constituency' do
    before do
      assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: true, start_date: Time.zone.now - 1.month, end_date: Time.now - 1.day))
      assign(:seat_incumbencies, [double(:seat_incumbencies, start_date: Time.zone.now - 1.month, end_date: nil, current?: true)])
      render
    end

    it 'will not render the dates for a current constituency' do
      expect(rendered).not_to match(/Current Constituency/)
    end
  end
end
