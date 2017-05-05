require 'rails_helper'

RSpec.describe 'parties/_party_list', vcr: true do
  context '@parties is empty' do
    before do
      assign(:parties, [])
      controller.params = { letter: 'a' }
      render
    end

    context 'partials' do
      it 'will render shared/_empty_list' do
        expect(response).to render_template(partial: 'shared/_empty_list')
      end
    end
  end

  context '@parties is not empty' do
    before do
      assign(:parties, [double(:party, name: 'Conservative', graph_id: 'jF43Jxoc')])
      render
    end

    context 'links' do
      it 'will link to party_path' do
        expect(rendered).to have_link('Conservative', href: party_path('jF43Jxoc'))
      end
    end
  end
end
