require 'rails_helper'

RSpec.describe 'houses/a_to_z_members', vcr: true do
  before do
    assign(:house_id, 'KL2k1BGP')
    assign(:letters, 'A')
    render
  end

  it 'will render pugin/components/_navigation-letter' do
    expect(response).to render_template(partial: 'pugin/components/_navigation-letter', locals: { route_args: ['KL2k1BGP']})
  end
end
