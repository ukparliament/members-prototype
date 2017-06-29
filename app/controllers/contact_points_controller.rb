class ContactPointsController < ApplicationController
  before_action :data_check

  def index
    @contact_points = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call,
      'http://id.ukpds.org/schema/ContactPoint'
    )
  end

  def show
    @contact_point = RequestHelper.filter_response_data(
      ROUTE_MAP[:show].call(params),
      'http://id.ukpds.org/schema/ContactPoint'
    ).first

    vcard = create_vcard(@contact_point)
    send_data vcard.to_s, filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false }
  end

  private

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.contact_points },
    show: proc { |params| ParliamentHelper.parliament_request.contact_points(params[:contact_point_id]) }
  }.freeze

  def data_url
    ROUTE_MAP[params[:action].to_sym]
  end
end
