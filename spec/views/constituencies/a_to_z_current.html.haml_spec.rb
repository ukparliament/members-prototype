require 'rails_helper'

RSpec.describe 'constituencies/a_to_z_current', vcr: true do
  before do
    assign(:letters, 'A')
    render
  end

  it 'will render pugin/components/_navigation-letter' do
    expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
  end
end
