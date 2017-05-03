# Namespace for Parliament::Request helper methods.
module RequestHelper
  # Handle Parliament::NoContentResponseError errors within a given request and executes a block when the exception is raised.
  #
  # @param [Parliament::Request] request a built Parliament::Request object that can just be called with #get
  # @param [Block] block a block to be executed if a Parliament error is raised.
  #
  # @example Handling a Parliament::NoContentResponseError
  #   # Build a request that we expect to fail
  #   request = Parliament::Request.new.people.members.current('x')
  #
  #   # If the request raises a Parliament::NoContentResponseError we will assign @people = []
  #   response = RequestHelper.handle(request) { @people = [] }
  #
  #   # If it was successful we will handle the data as expected
  #   @people = response[:response].filter('http://id.ukpds.org/schema/Person') if response[:success]
  #
  # @return [Hash] a return object in the format:
  #   { success: true, response: #<Parliament::Response> } for a successful request or
  #   { success: false, response: nil } for a response that threw an error.
  def self.handle(request, &block)
    return_object = { success: false, response: nil }

    begin
      response = request.get
      return_object = { success: true, response: response }
    rescue Parliament::NoContentResponseError => e
      Rails.logger.warn "Received 204 status from #{e}"
      block&.call
    end

    return_object
  end

  # Takes a Parliament::Request and calls the #get method.
  # Then maps the #value method on the resulting response.
  #
  # @param [Parliament::Request] request a built Parliament::Request object that can just be called with #get
  #
  # @return [Array<String>]
  def self.process_available_letters(request)
    response = request.get
    response.map(&:value)
  end

  # Takes a Parliament::Request and a optional amount of filters and calls the #get method on on the request.
  # Then calls Parliament::Response#filter with the filters as the parameters on the resulting response 
  #
  # @param [Parliament::Request] request a built Parliament::Request object that can just be called with #get
  #
  # @return [Parliament::Response]
  def self.filter_response_data(request, *filters)
    response = request.get
    response.filter(*filters)
  end
end
