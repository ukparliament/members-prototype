module People
  class MediaController < ApplicationController
    before_action :data_check, :build_request

    ROUTE_MAP = {
      show: proc { |params| ParliamentHelper.parliament_request.people(params[:person_id]).media(params[:media_id]) }
    }.freeze

    def show
      @person = RequestHelper.filter_response_data(
        @request,
        'http://id.ukpds.org/schema/Person'
      )

      @person = @person.first
    end
  end
end
