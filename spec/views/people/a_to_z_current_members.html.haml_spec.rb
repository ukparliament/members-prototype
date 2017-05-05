require 'rails_helper'

RSpec.describe 'people/a_to_z_current_members', vcr: true do
  before do
    assign(:letters, 'A')
    assign(:person_id, 'jF43Jxoc')
    render
  end

  it 'will render pugin/components/_navigation-letter' do
    expect(response).to render_template(partial: 'pugin/components/_navigation-letter')
  end
end
