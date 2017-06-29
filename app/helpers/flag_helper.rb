module FlagHelper
  def self.dissolution?
    # When in the dissolution period
    BANDIERA_CLIENT.enabled?('parliament', 'show-dissolution')
  end

  def self.register_to_vote?
    # When in dissolution but still in the registration period
    BANDIERA_CLIENT.enabled?('parliament', 'show-register')
  end

  def self.election?
    BANDIERA_CLIENT.enabled?('parliament', 'show-election')
  end

  def self.post_election?
    BANDIERA_CLIENT.enabled?('parliament', 'show-post-election')
  end

  def self.election_period?
    (election? == true || post_election? == true)
  end
end
