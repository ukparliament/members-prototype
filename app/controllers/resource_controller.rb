class ResourceController < ApplicationController
  before_action :resource_params, only: :show
  # before_action :data_check

  def index
    raise ActionController::RoutingError, 'Not Found'
  end

  def show
    @results = parliament_request.resources.get(params: { uri: @resource_uri })

    types = ResourceHelper.store_types(@results)
    path = ResourceHelper.check_acceptable_object_type(types)

    return redirect_to "/#{path}/#{@resource_id}" if path

    @statements = ResourceHelper.produce_statements(@results)
  end

  private

  def resource_params
    @resource_id = params[:resource_id]
    @resource_uri = "http://id.ukpds.org/#{@resource_id}"
  end
end
