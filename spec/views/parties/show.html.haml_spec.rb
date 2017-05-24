require 'rails_helper'

RSpec.describe 'parties/show', vcr: true do
  context 'header' do
    it 'will render the correct header' do
      assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', member_count: 10, current?: true))
      render
      expect(rendered).to match(/Conservative/)
    end
  end

  context '@party.member_count > 0' do
    before do
      assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', member_count: 10, current?: true))
      render
    end

    context 'links' do
      it 'will render link to party_members_current_path' do
        expect(rendered).to have_link('Current members', href: party_members_current_path('jF43Jxoc'))
      end

      it 'will render link description' do
        expect(rendered).to match(/View all current Conservative members/)
      end
    end
  end

  context '@party.member_count == 0' do
    before do
      assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', member_count: 0, current?: false))
      render
    end

    context 'links' do
      it 'will render link to party_members_path' do
        expect(rendered).to have_link('View all former Conservative members', href: party_members_path('jF43Jxoc'))
      end
    end
  end
end
