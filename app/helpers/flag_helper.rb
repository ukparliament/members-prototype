module FlagHelper
  def self.dissolution?
    BANDIERA_CLIENT.enabled?('parliament', 'show-dissolution')
  end

  def self.register_to_vote?
    BANDIERA_CLIENT.enabled?('parliament', 'show-register')
  end

  def self.dissolution_singular?
    # When there is no MP, Dissolutions or By-elections
    BANDIERA_CLIENT.enabled?('parliament', 'show-dissolution-singular')
  end
end
