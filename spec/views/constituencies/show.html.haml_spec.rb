require 'rails_helper'

RSpec.describe 'constituencies/show', vcr: true do
  before do
    assign(:constituency, double(:constituency, name: 'Aberavon', graph_id: 'MtbjxRrE', start_date: nil, end_date: nil, current?: true))
    assign(:seat_incumbencies, [double(:seat_incumbencies, start_date: nil, end_date: nil, current?: true)])
    render
  end

  context 'header' do
    it 'will render the correct header' do
      expect(rendered).to match(/Aberavon/)
    end
  end

  context 'partials' do
    it 'will render constituencies/constituencies' do
      expect(response).to render_template(partial: 'constituencies/_constituency')
    end
  end
end
