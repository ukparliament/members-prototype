require 'rails_helper'

RSpec.describe FlagHelper do
  context'with BANDIERA_CLIENT responding with false' do
    describe '#dissolution?' do
      it { expect(subject.dissolution?).to eq(false) }
    end

    describe '#register_to_vote?' do
      it { expect(subject.register_to_vote?).to eq(false) }
    end

    describe '#election?' do
      it { expect(subject.election?).to eq(false) }
    end

    describe '#post_election?' do
      it { expect(subject.post_election?).to eq(false) }
    end

    describe '#election_period?' do
      it { expect(subject.election_period?).to eq(false) }
    end
  end

  context'with BANDIERA_CLIENT responding with true' do
    before :each do
      allow(BANDIERA_CLIENT).to receive(:enabled?).and_return(true)
    end

    describe '#dissolution?' do
      it { expect(subject.dissolution?).to eq(true) }
    end

    describe '#register_to_vote?' do
      it { expect(subject.register_to_vote?).to eq(true) }
    end

    describe '#election?' do
      it { expect(subject.election?).to eq(true) }
    end

    describe '#post_election?' do
      it { expect(subject.post_election?).to eq(true) }
    end

    describe '#election_period?' do
      it { expect(subject.election_period?).to eq(true) }
    end
  end
end
