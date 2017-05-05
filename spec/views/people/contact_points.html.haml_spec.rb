require 'rails_helper'

RSpec.describe 'people/contact_points', vcr: true do
  before do
    assign(:person, double(:person, display_name: 'Test Name'))
    assign(:contact_points, [double(:contact_point, email: 'testemail@test.com', phone_number: '07700000000', fax_number: '01230000000', postal_addresses: [double(:postal_address, full_address: 'Test Address')], graph_id: '8ONg5lY6')])
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Test Name - Contact details/)
    end
  end

  context 'contact details' do
    context 'email' do
      it 'will render email' do
        expect(rendered).to match(/testemail@test.com/)
      end
    end

    context 'phone number' do
      it 'will render phone number' do
        expect(rendered).to match(/07700000000/)
      end
    end

    context 'fax number' do
      it 'will render fax number' do
        expect(rendered).to match(/01230000000/)
      end
    end

    context 'postal address' do
      it 'will render postal address' do
        expect(rendered).to match(/Test Address/)
      end
    end
  end

  context 'links' do
    it 'will render link to contact_point_path' do
      expect(rendered).to have_link('Add to address book', href: contact_point_path('8ONg5lY6'))
    end
  end
end
