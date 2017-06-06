require 'rails_helper'

RSpec.describe ViewHelper, vcr: true do

  it 'should convert house membership status' do
    statuses = ['Member of the House of Lords', 'Former MP']
    expect(ViewHelper.convert_house_membership_status(statuses)).to eq(['Member of the House of Lords', 'former MP'])
  end

end
