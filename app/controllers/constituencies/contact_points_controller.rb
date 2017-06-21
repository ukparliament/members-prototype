module Constituencies
  class ContactPointsController < ApplicationController
    before_action :data_check

    # Renders a contact point given a constituency id.
    # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
    # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup' which has a contact point.

    def index
      constituency_id = params[:constituency_id]

      @constituency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id).contact_point,
      'http://id.ukpds.org/schema/ConstituencyGroup'
      ).first
    end

    private

    ROUTE_MAP = {
      index: proc { |params| ParliamentHelper.parliament_request.constituencies(params[:constituency_id]).contact_point }
      }.freeze

    def data_url
      ROUTE_MAP[params[:action].to_sym]
    end
  end
end
