module RequestHelper
  # Runs a subprocess and applies handlers for request and a block of code as an argument
  # Params:
  # - return_object: The data returned by the api showing the actual data response: and success: or fail:
  # - to show if there was a successful response from the api
  # - block: proc object that is executed within the module only if the response: is nil and success: is false triggering
  # - a rescue

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
