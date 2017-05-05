require 'rails_helper'

RSpec.describe 'constituencies/current_member', vcr: true do
  before(:each) do
    allow(FlagHelper).to receive(:dissolution?).and_return(true)
  end

  context 'header' do
    before do
      assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: true, start_date: Time.zone.now - 1.month))
      assign(:seat_incumbency, double(:seat_incumbency, start_date: Time.zone.now - 2.month, end_date: nil, current?: true, member: double(:member, display_name: 'Test Name', graph_id: '7TX8ySd4')))
      render
    end

    it 'will render constituency name' do
      expect(rendered).to match(/Aberavon - Current MP/)
    end
  end

  context '@constituency' do
    context 'current?' do
      context 'is current' do
        before do
          assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: true, start_date: Time.zone.now - 1.month))
          assign(:seat_incumbency, double(:seat_incumbency, start_date: Time.zone.now - 2.month, end_date: nil, current?: true, member: double(:member, display_name: 'Test Name', graph_id: '7TX8ySd4')))
          render
        end

        it 'will render correct content' do
          expect(rendered).to match(/Current constituency/)
          expect("#{(Time.zone.now - 1.month).strftime('%-e %b %Y')} to present")
        end
      end

      context 'is not current' do
        before do
          assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: false, start_date: Time.zone.now - 1.month, end_date: Time.zone.now - 1.day))
          assign(:seat_incumbency, double(:seat_incumbency, start_date: Time.zone.now - 2.month, end_date: nil, current?: true, member: double(:member, display_name: 'Test Name', graph_id: '7TX8ySd4')))
          render
        end

        it 'will render correct content' do
          expect(rendered).to match(/Former constituency/)
          expect("#{(Time.zone.now - 1.month).strftime('%-e %b %Y')} to #{(Time.zone.now - 1.day).strftime('%-e %b %Y')}")
        end
      end
    end
  end

  context '@seat_incumbency' do
    context 'links' do
      before do
        assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: false, start_date: Time.zone.now - 1.month, end_date: Time.zone.now - 1.day))
        assign(:seat_incumbency, double(:seat_incumbency, start_date: Time.zone.now - 2.month, end_date: nil, current?: true, member: double(:member, display_name: 'Test Name', graph_id: '7TX8ySd4')))
        render
      end
      it 'will render link to person_path' do
        expect(rendered).to have_link('Test Name', href: person_path('7TX8ySd4'))
      end
    end

    context 'start date' do
      context 'nil' do
        before do
          assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: false, start_date: Time.zone.now - 1.month, end_date: Time.zone.now - 1.day))
          assign(:seat_incumbency, double(:seat_incumbency, start_date: Time.zone.now - 2.month, end_date: nil, current?: true, member: double(:member, display_name: 'Test Name', graph_id: '7TX8ySd4')))
          render
        end

        it 'will render start date' do
          expect(rendered).to match("#{(Time.zone.now - 2.month).strftime('%-e %b %Y')} to present")
        end
      end

      context 'not nil' do
        before do
          assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: false, start_date: Time.zone.now - 1.month, end_date: Time.zone.now - 1.day))
          assign(:seat_incumbency, double(:seat_incumbency, start_date: nil, end_date: nil, current?: true, member: double(:member, display_name: 'Test Name', graph_id: '7TX8ySd4')))
          render
        end

        it 'will not render start date' do
          expect(rendered).not_to match("#{(Time.zone.now - 2.month).strftime('%-e %b %Y')} to present")
        end
      end
    end
  end

  context 'partials' do
    before do
      assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: true, start_date: Time.zone.now - 1.month))
      assign(:seat_incumbency, double(:seat_incumbency, start_date: Time.zone.now - 2.month, end_date: nil, current?: true, member: double(:member, display_name: 'Test Name', graph_id: '7TX8ySd4')))
      render
    end

    it 'will render dissolution message' do
      render
      expect(response).to render_template(partial: 'shared/_dissolution_message')
    end
  end
end
