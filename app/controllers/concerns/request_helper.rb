module RequestHelper
  # @param [Parliament::Request] request the request we are going to attempt to make
  # @param [Block] block block to be executed if we get a 204 error
  #
  # @return [Hash] a response object with the format { success: Boolean, response: Parliament::Response }
  def self.handler(request, &block)
    return_object = { success: false, response: nil }
    begin
      response = request.get
      return_object = { success: true, response: response }
    rescue Parliament::NoContentError => e
      Rails.logger.warn "Received 204 status from #{e}"
      block&.call
    end
    return return_object
  end
end
