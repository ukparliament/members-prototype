# Namespace for Parliament::Request helper methods.
module RequestHelper
  # Handle Parliament::NoContentResponseError errors within a given request.
  #
  # @param [Parliament::Request] request a built Parliament::Request object that can just be called with #get
  # @param [Block] block a block to be executed if a Parliament error is raised.
  #
  # @return [Hash] a return object in the format:
  #   { success: true, response: #<Parliament::Response> } for a successful request or
  #   { success: false, response: nil } for a response that threw an error.
  def self.handler(request, &block)
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
end
