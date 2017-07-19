class MediaController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show: proc {|params| ParliamentHelper.parliament_request.media(params[:medium_id])}
  }.freeze

  def index
    raise ActionController::RoutingError, 'Not Found'
  end

  def show
    @image, @person = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/MemberImage',
      'http://id.ukpds.org/schema/Person'
    )

    @image = @image.first

    @person = @person.first
  end
end
