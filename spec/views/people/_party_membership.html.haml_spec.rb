require 'rails_helper'

RSpec.describe 'people/_party_membership', vcr: true do
  context 'links' do
    before do
      party_membership = double(:party_membership,
        start_date: Time.zone.now - 1.month,
        end_date:   nil,
        party:      double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'))

      allow(party_membership).to receive(:current?).and_return(true)
      render partial: 'people/party_membership', locals: { party_membership: party_membership }
    end

    it 'will render link to party_path' do
      expect(rendered).to have_link('Conservative', href: party_path('jF43Jxoc'))
    end
  end

  context 'start date' do
    context 'is nil' do
      before do
        party_membership = double(:party_membership,
          start_date: nil,
          end_date:   nil,
          party:      double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'))

        allow(party_membership).to receive(:current?).and_return(true)
        render partial: 'people/party_membership', locals: { party_membership: party_membership }
      end

      it 'will not render start date' do
        expect(rendered).not_to match((Time.zone.now - 1.day).strftime('%-e %b %Y'))
      end
    end

    context 'is not nil' do
      before do
        party_membership = double(:party_membership,
          start_date: Time.zone.now - 1.month,
          end_date:   nil,
          party:      double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'))

        allow(party_membership).to receive(:current?).and_return(true)
        render partial: 'people/party_membership', locals: { party_membership: party_membership }
      end

      it 'will render the start date' do
        expect(rendered).to match((Time.zone.now - 1.month).strftime('%-e %b %Y'))
      end
    end
  end

  context 'party_membership.current?' do
    context 'is current' do
      before do
        party_membership = double(:party_membership,
          start_date: Time.zone.now - 1.month,
          end_date:   nil,
          party:      double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'))

        allow(party_membership).to receive(:current?).and_return(true)
        render partial: 'people/party_membership', locals: { party_membership: party_membership }
      end

      it 'will render correct text' do
        expect(rendered).to match(/to present/)
      end
    end

    context 'is not current' do
      before do
        party_membership = double(:party_membership,
          start_date: Time.zone.now - 1.month,
          end_date:   Time.zone.now - 1.day,
          party:      double(:party, name: 'Conservative', graph_id: 'jF43Jxoc'))

        allow(party_membership).to receive(:current?).and_return(false)
        render partial: 'people/party_membership', locals: { party_membership: party_membership }
      end

      it 'will render end date' do
        expect(rendered).to match("to #{(Time.zone.now - 1.day).strftime('%-e %b %Y')}")
      end
    end
  end
end
