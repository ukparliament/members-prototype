require 'rails_helper'

RSpec.describe 'constituencies/_constituencies' do
  context '@constituencies is empty' do
    before do
      assign(:constituencies, [])
      controller.params = { letter: 'a' }
      render
    end

    it 'will render shared/empty_list' do
      expect(response).to render_template(partial: 'shared/_empty_list')
    end
  end

  context '@constituencies is not empty' do
    context 'current constituency' do
      before do
        assign(:constituencies, [
                 double(:constituency,
                   name:       'Aberconwy',
                   graph_id:   'NJNMQ58K',
                   current?:   true,
                   start_date: Time.zone.now - 1.month,
                   end_date:   nil)
               ])
        render
      end

      it 'will render constituency name' do
        expect(rendered).to match(/Aberconwy/)
      end

      it 'will render current status' do
        expect(rendered).to match(/Current constituency/)
      end

      it 'will render present status' do
        expect(rendered).to match(/to present/)
      end

      it 'will render constituency with start date' do
        expect(rendered).to match("from #{(Time.zone.now - 1.month).strftime('%-e %b %Y')}")
      end
    end

    context 'former constituency' do
      before do
        assign(:constituencies, [
                 double(:constituency,
                   name:       'Aberavon',
                   graph_id:   'MtbjxRrE',
                   current?:   false,
                   start_date: Time.zone.now - 1.month,
                   end_date:   Time.zone.now - 1.day)
               ])
        render
      end

      it 'will render constituency name' do
        expect(rendered).to match(/Aberavon/)
      end

      it 'will render constituency status' do
        expect(rendered).to match(/Former constituency/)
      end

      it 'will render constituency with start and end date' do
        expect(rendered).to match("from #{(Time.zone.now - 1.month).strftime('%-e %b %Y')}")
      end

      it 'will render constituency end date' do
        expect(rendered).to match("to #{(Time.zone.now - 1.day).strftime('%-e %b %Y')}")
      end
    end
  end
end
