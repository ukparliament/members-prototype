require 'rails_helper'

RSpec.describe 'postcodes/show', vcr: true do
  before do
    assign(:postcode, 'SW1A 0AA')
    assign(:constituency,
      double(:constituency,
        name:     'Test Constituency Name',
        graph_id: 'MtbjxRrE',
        members:  [
          double(:member,
            display_name: 'Test Display Name',
            graph_id:     '7TX8ySd4',
            parties:      [
              double(:party,
                name: 'Test Party Name')
            ])
        ]))

    render
  end

  context 'content' do
    it 'will render the party name' do
      expect(rendered).to match(/Test Party Name/)
    end
  end

  context 'links' do
    it 'will render link to person_path' do
      expect(rendered).to have_link('Test Display Name', href: person_path('7TX8ySd4'))
    end

    it 'will render link to constituency_path' do
      expect(rendered).to have_link('Test Constituency Name', href: constituency_path('MtbjxRrE'))
    end
  end
end
