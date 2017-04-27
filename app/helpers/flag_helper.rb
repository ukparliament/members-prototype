module FlagHelper
  def self.dissolution?
    BANDIERA_CLIENT.enabled?('parliament', 'show-dissolution')
  end
end
