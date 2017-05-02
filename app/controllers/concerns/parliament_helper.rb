require 'parliament/grom/decorator'
require 'parliament'
require 'parliament/ntriple'

module ParliamentHelper
  def self.parliament_request
    Parliament::Request::UrlRequest.new(
      builder:    Parliament::Builder::NTripleResponseBuilder,
      headers:    { 'Ocp-Apim-Subscription-Key': ENV['PARLIAMENT_AUTH_TOKEN'] },
      decorators: Parliament::Grom::Decorator
    )
  end

  def parliament_request
    ParliamentHelper.parliament_request
  end
end
