require 'rails_helper'

RSpec.describe 'people/_person', vcr: true do
  before do
    person = double(:person, full_name: 'Test Person', graph_id: '7TX8ySd4')

    render partial: 'people/person', locals: { person: person }
  end

  context 'links' do
    it 'will render link to person_path' do
      expect(rendered).to have_link('Test Person', href: person_path('7TX8ySd4'))
    end
  end
end
