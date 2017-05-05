require 'rails_helper'

RSpec.describe 'constituencies/_current_constituencies', vcr: true do
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
    before do
      assign(:constituencies, [double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', current?: true, members: []),
                               double(:constituency, name: 'Aberconwy', graph_id: 'NJNMQ58K', current?: true, members: [double(:member, display_name: 'Test Name')])])
      render
    end

    it 'will list constituencies' do
      expect(rendered).to match(/Aberavon/)
      expect(rendered).to match(/Aberconwy/)
    end

    context 'constituency members is empty' do
      it 'will render vacancy' do
        expect(rendered).to match(/Vacant/)
      end
    end

    context 'constituency members is not empty' do
      it 'will render MPs display name' do
        expect(rendered).to match(/Test Name MP/)
      end
    end
  end
end
