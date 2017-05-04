module FlagHelper
  def self.dissolution?
    BANDIERA_CLIENT.enabled?('parliament', 'show-dissolution')
  end

  def self.register_to_vote?
    BANDIERA_CLIENT.enabled?('parliament', 'show-register')
  end
end
