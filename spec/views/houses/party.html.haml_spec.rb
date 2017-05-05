require 'rails_helper'

RSpec.describe 'houses/party', vcr: true do
  context 'member count > 1' do
    before do
      assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'))
      assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', member_count: 10))
      assign(:current_person_type, 'MPs')
      assign(:other_person_type, 'Lords')
      assign(:other_house_id, 'f1a325bf-f550-48a5-ad40-e30cb7b7bdf4')
      assign(:house_id, 'KL2k1BGP')
      assign(:party_id, 'jF43Jxoc')
      assign(:letters, 'A')
      controller.params = { letter: 'a' }

      render
    end

    context 'header' do
      it 'will render the page title' do
        expect(rendered).to match(/Conservative - House of Commons/)
      end
    end

    context 'link' do
      it 'will render house_parties_party_members_current_a_z_letter_path' do
        expect(rendered).to have_link('Conservative MPs', href: house_parties_party_members_current_a_z_letter_path('KL2k1BGP', 'jF43Jxoc', 'a'))
      end

      it 'will have correct description' do
        expect(rendered).to match(/View all Conservative members in the House of Commons/)
      end
    end
  end

  context 'member count == 0' do
    before do
      assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'))
      assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', member_count: 0))
      assign(:current_person_type, 'MPs')
      assign(:other_person_type, 'Lords')
      assign(:other_house_id, 'f1a325bf-f550-48a5-ad40-e30cb7b7bdf4')
      assign(:house_id, 'KL2k1BGP')
      assign(:party_id, 'jF43Jxoc')
      assign(:letters, 'A')
      controller.params = { letter: 'a' }

      render
    end

    it 'will show no party members' do
      expect(rendered).to match(/There are currently no members of this party in this House./)
    end

    context 'link' do
      it 'will render house_parties_party_members_path' do
        expect(rendered).to have_link('Current and former Conservative MPs', href: house_parties_party_members_path('KL2k1BGP', 'jF43Jxoc'))
      end

      it 'will have correct description' do
        expect(rendered).to match(/View all current and former Conservative members/)
      end
    end
  end
end
