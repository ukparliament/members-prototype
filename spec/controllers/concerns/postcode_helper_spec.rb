require 'rails_helper'

RSpec.describe PostcodeHelper, vcr: true do
  it 'is a module' do
    expect(PostcodeHelper).to be_a(Module)
  end

  context 'given a valid postcode (no whitespace)' do
    it 'returns a Parliament::Response::NTripleResponse' do
      result = PostcodeHelper.lookup('E20JA')

      expect(result).to be_a(Parliament::Response::NTripleResponse)
      expect(result.nodes.first.constituencyGroupName).to eq('constituencyGroupName - 1')
    end
  end

  context 'given a valid postcode (containing whitespace)' do
    it 'returns a Parliament::Response::NTripleResponse' do
      result = PostcodeHelper.lookup(' E2  0JA ')

      expect(result).to be_a(Parliament::Response::NTripleResponse)
      expect(result.nodes.first.constituencyGroupName).to eq('constituencyGroupName - 1')
    end
  end

  context 'given an invalid postcode (containing non-postcode characters)' do
    it 'raises a PostcodeHelper::PostcodeError' do
      expect{ PostcodeHelper.lookup("<E2'0JA>") }.to raise_error(PostcodeHelper::PostcodeError, 'Your postcode is invalid.')
    end
  end

  context 'given an invalid postcode (containing valid postcode characters)' do
    it 'raises a PostcodeHelper::PostcodeError' do
      expect{ PostcodeHelper.lookup('JE2 4NJ') }.to raise_error(PostcodeHelper::PostcodeError, 'No constituency found for the postcode entered.')
    end
  end

  context 'given the endpoint is down' do
    it 'raises a PostcodeHelper::PostcodeError' do
      stub_request(:get, "#{ENV['PARLIAMENT_BASE_URL']}/constituencies/postcode_lookup/E20JA").
        to_return(status: [500, 'Internal Server Error'])

      expect{ PostcodeHelper.lookup('E2 0JA') }.to raise_error(PostcodeHelper::PostcodeError, 'Postcode lookup is currently unavailable.')
    end
  end

  context '#hyphenate' do
    it 'removes whitespace and adds a hyphen to a postcode' do
      expect(PostcodeHelper.hyphenate('E2 0SE')).to eq('E2-0SE')
    end
  end

  context '#unhyphenate' do
    it 'restores space and removes the hyphen from a postcode' do
      expect(PostcodeHelper.unhyphenate('E2-0SE')).to eq('E2 0SE')
    end
  end

  context '#previous_path' do
    it 'returns the previous path' do
      PostcodeHelper.previous_path = '/constituencies/current'

      expect(PostcodeHelper.previous_path).to eq('/constituencies/current')
    end
  end
end
