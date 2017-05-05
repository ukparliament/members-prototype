require 'rails_helper'

RSpec.describe 'people/_incumbency', vcr: true do
  context 'incumbency house is nil' do
    before do
      incumbency = double(:incumbency,
        start_date: Time.zone.now - 1.month,
        end_date:   nil,
        house:      nil,
        seat:       double(:seat, house: double(:house, name: 'House of Lords', graph_id: 'm1EgVTLj')))
      allow(incumbency).to receive(:current?).and_return(true)
      render partial: 'people/incumbency', locals: { incumbency: incumbency }
    end

    context 'links' do
      it 'will link to house_path' do
        expect(rendered).to have_link('House of Lords', href: house_path('m1EgVTLj'))
      end
    end
  end

  context 'incumbency house is not nil' do
    before do
      incumbency = double(:incumbency,
        start_date: Time.zone.now - 1.month,
        end_date:   nil,
        house:      double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'),
        seat:       double(:seat, house: double(:house, name: 'House of Lords', graph_id: 'm1EgVTLj')))
      allow(incumbency).to receive(:current?).and_return(true)
      render partial: 'people/incumbency', locals: { incumbency: incumbency }
    end

    context 'links' do
      it 'will link to house_path' do
        expect(rendered).to have_link('House of Commons', href: house_path('KL2k1BGP'))
      end
    end
  end

  context 'incumbency start date is nil' do
    before do
      incumbency = double(:incumbency,
        start_date: nil,
        end_date:   nil,
        house:      double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'),
        seat:       double(:seat, house: double(:house, name: 'House of Lords', graph_id: 'm1EgVTLj')))
      allow(incumbency).to receive(:current?).and_return(true)
      render partial: 'people/incumbency', locals: { incumbency: incumbency }
    end

    it 'will not render start date' do
      expect(rendered).not_to match((Time.zone.now - 1.month).strftime('%-e %b %Y'))
    end
  end

  context 'incumbency.current?' do
    context 'not current' do
      before do
        incumbency = double(:incumbency,
          start_date: Time.zone.now - 1.month,
          end_date:   Time.zone.now - 1.day,
          house:      double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'),
          seat:       double(:seat, house: double(:house, name: 'House of Lords', graph_id: 'm1EgVTLj')))
        allow(incumbency).to receive(:current?).and_return(false)
        render partial: 'people/incumbency', locals: { incumbency: incumbency }
      end

      it 'will render end date' do
        expect(rendered).to match("to #{(Time.zone.now - 1.day).strftime('%-e %b %Y')}")
      end
    end

    context 'is current' do
      before do
        incumbency = double(:incumbency,
          start_date: Time.zone.now - 1.month,
          end_date:   nil,
          house:      double(:house, name: 'House of Commons', graph_id: 'KL2k1BGP'),
          seat:       double(:seat, house: double(:house, name: 'House of Lords', graph_id: 'm1EgVTLj')))
        allow(incumbency).to receive(:current?).and_return(true)
        render partial: 'people/incumbency', locals: { incumbency: incumbency }
      end

      it 'will render correct text' do
        expect(rendered).to match(/to present/)
      end
    end
  end
end
