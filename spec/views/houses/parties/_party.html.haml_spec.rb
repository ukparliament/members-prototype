require 'rails_helper'
require 'parliament'

RSpec.describe 'houses/parties/_party', vcr: true do
  before do
    assign(:house, double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'))
  end

  context 'party#member_count' do
    context 'is nil' do
      before do
        render partial: 'houses/parties/party', locals: { party: double(:party, member_count: nil, name: 'Test Party Without Members', graph_id: 'pPvA9vKP') }
      end

      it 'will link to the party' do
        expect(rendered).to have_link('Test Party Without Members', href: house_parties_party_members_current_path('KL2k1BGP', 'pPvA9vKP'))
      end
    end

    context 'is not nil' do
      before do
        render partial: 'houses/parties/party', locals: { party: double(:party, name: 'Test Party With Members', graph_id: 'pPvA9vKP', member_count: 10) }
      end

      it 'will link to the party' do
        expect(rendered).to have_link('Test Party With Members', href: house_parties_party_members_current_path('KL2k1BGP', 'pPvA9vKP'))
      end

      it 'will render members count' do
        expect(rendered).to match(/10/)
      end

      it 'will render link description' do
        expect(rendered).to match(/View all current Test Party With Members MPs/)
      end

      context 'party is the Speaker of the House' do
        before do
          render partial: 'houses/parties/party', locals: { party: double(:party, name: 'The Speaker of the House of Commons', graph_id: 'KL2k1BGP', member_count: 1) }
        end

        it 'will render the Speaker' do
          expect(rendered).to match(/The Speaker of the House of Commons/)
        end
      end
    end
  end
end
