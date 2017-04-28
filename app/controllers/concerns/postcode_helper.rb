require 'parliament_helper'

# Namespace for postcode helper methods.
#
# attr [String] previous_path the path to redirect back to in the case of an error.
module PostcodeHelper
  attr_accessor :previous_path

  # Makes requests to the postcode_lookup endpoint.
  # @param [String] raw_input the data inputted by the user.
  # @return [Parliament::Response::NTripleResponse, Parliament::ClientError, Parliament::ServerError] if successful, a response is returned, otherwise an error is returned.
  def self.lookup(raw_input)
    postcode = clean_input(raw_input)

    begin
      ParliamentHelper.parliament_request.constituencies.postcode_lookup(postcode).get
    rescue Parliament::ClientError
      raise(PostcodeError, I18n.t('error.no_constituency'))
    rescue Parliament::ServerError
      raise(PostcodeError, I18n.t('error.lookup_unavailable'))
    end
  end

  # Replaces whitespace with a hyphen.
  # @param [String] postcode the string to be hyphenated.
  # @return [String] a hyphenated string.
  def self.hyphenate(postcode)
    postcode.strip.gsub(/\s+/, '-')
  end

  # Replaces a hyphen with whitespace, restoring a postcode to its usual format.
  # @param [String] postcode the string to be processed.
  # @return [String] the restored postcode with hyphen replaced by whitespace.
  def self.unhyphenate(postcode)
    postcode.tr('-', ' ')
  end

  # Returns the previous path variable.
  # @return [String] previous_path the path to redirect back to in the case of an error.
  def self.previous_path
    @previous_path
  end

  # Sets the previous path variable.
  # @return [String] previous_path the path to redirect back to in the case of an error.
  def self.previous_path=(path)
    @previous_path = path
  end

  private_class_method

  def self.clean_input(raw_input)
    postcode = raw_input.gsub(/\s+/, '')
    postcode.match(/[^a-zA-Z0-9]/).nil? ? postcode : raise(PostcodeError, I18n.t('error.postcode_invalid'))
  end

  class PostcodeError < StandardError
    def initialize(message)
      super(message)
    end
  end
end
