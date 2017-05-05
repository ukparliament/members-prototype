require 'rails_helper'

RSpec.describe 'contact_points/index', vcr: true do
  before do
    assign(:contact_points, [double(:contact_point, email: 'test@email.com', phone_number: '07777777777', fax_number: '07777777778', graph_id: '8ONg5lY6', postal_addresses: [double(:postal_address, full_address: 'Test Address')])])
    render
  end

  context '@contact_points' do
    it 'will render email' do
      expect(rendered).to match(/test@email.com/)
    end

    it 'will render phone number' do
      expect(rendered).to match(/07777777777/)
    end

    it 'will render fax number' do
      expect(rendered).to match(/07777777778/)
    end
  end

  context 'contact_point.postal_addresses' do
    it 'will render full address' do
      expect(rendered).to match(/Test Address/)
    end

    it 'will render link' do
      expect(rendered).to have_link('Add to address book', href: contact_point_path('8ONg5lY6'))
    end
  end
end
