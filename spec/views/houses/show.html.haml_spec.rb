require 'rails_helper'

RSpec.describe 'houses/show', vcr: true do
  context 'Commons' do
    before do
      assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'))
      render
    end

    context 'header' do
      it 'will render the house name' do
        expect(rendered).to match(/House of Commons/)
      end
    end

    context 'links' do
      context 'members' do
        it 'will link to house_members_current_a_z_letter_path' do
          expect(rendered).to have_link('MPs', href: house_members_current_a_z_letter_path('KL2k1BGP', 'a'))
        end

        it 'will render link description' do
          expect(rendered).to match(/All current members of the House of Commons/)
        end
      end

      context 'parties' do
        it 'will link to house_parties_current_path' do
          expect(rendered).to have_link('Parties', href: house_parties_current_path('KL2k1BGP'))
        end

        it 'will render link description' do
          expect(rendered).to match(/All current parties in the House of Commons/)
        end
      end

      context 'constituencies' do
        it 'will link to constituencies_current_a_z_letter_path' do
          expect(rendered).to have_link('Constituencies', href: constituencies_current_a_z_letter_path('a'))
        end

        it 'will render link description' do
          expect(rendered).to match(/Find MPs by the area they represent/)
        end
      end
    end
  end

  context 'Lords' do
    before do
      assign(:house, double(:house, name: 'House of Lords', graph_id: 'm1EgVTLj'))
      render
    end

    context 'header' do
      it 'will render the house name' do
        expect(rendered).to match(/House of Lords/)
      end
    end

    context 'links' do
      it 'will link to house_members_current_a_z_letter_path' do
        expect(rendered).to have_link('Lords', href: house_members_current_a_z_letter_path('m1EgVTLj', 'a'))
      end

      it 'will link to house_parties_current_path' do
        expect(rendered).to have_link('Parties and groups', href: house_parties_current_path('m1EgVTLj'))
      end

      it 'will render link description' do
        expect(rendered).to match(/All current parties and groups in the House of Lords/)
      end
    end
  end
end
