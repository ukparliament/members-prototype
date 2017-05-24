# Namespace for Parliament::Request helper methods.
module RequestHelper
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
  # Then calls Parliament::Response#filter with the filters as the parameters on the resulting response.
  #
  # @param [Parliament::Request] request a built Parliament::Request object that can just be called with #get
  #
  # @return [Parliament::Response]
  def self.filter_response_data(request, *filters)
    response = request.get
    response.filter(*filters)
  end
end
