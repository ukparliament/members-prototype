require 'rails_helper'

RSpec.describe 'parties/a_to_z_members', vcr: true do
  before do
    assign(:letters, 'A')
    assign(:party_id, 'jF43Jxoc')
    render
  end

  it 'will render pugin/components/_navigation-letter' do
    expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
  end
end
