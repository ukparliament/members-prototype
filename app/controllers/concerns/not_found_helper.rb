module NotFoundHelper
  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
