require 'rails_helper'

RSpec.describe 'people/current_party', vcr: true do
  before do
    assign(:person, double(:person, display_name: 'Test Name'))
  end

  context 'header' do
    before do
      assign(:party, nil)
      render
    end

    it 'will render the correct header' do
      expect(rendered).to match(/Test Name - Current party/)
    end
  end

  context '@party' do
    context 'nil' do
      before do
        assign(:party, nil)
        render
      end

      it 'will not render link to party_path' do
        expect(rendered).not_to have_link('Conservative', href: party_path('jF43Jxoc'))
      end
    end

    context 'not nil' do
      before do
        assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', party_memberships: [double(:party_membership, start_date: nil)]))
        render
      end

      it 'will render link to party_path' do
        expect(rendered).to have_link('Conservative', href: party_path('jF43Jxoc'))
      end

      context 'house seat incumbency start date' do
        context 'nil' do
          before do
            assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', party_memberships: [double(:party_membership, start_date: nil)]))
            render
          end

          it 'will not render link description' do
            expect(rendered).not_to match("#{(Time.zone.now - 2.month).strftime('%-e %b %Y')} to present")
          end
        end

        context 'not nil' do
          before do
            assign(:party, double(:party, name: 'Conservative', graph_id: 'jF43Jxoc', party_memberships: [double(:party_membership, start_date: Time.zone.now - 2.month)]))
            render
          end

          it 'will render link description' do
            expect(rendered).to match("#{(Time.zone.now - 2.month).strftime('%-e %b %Y')} to present")
          end
        end
      end
    end
  end
end
