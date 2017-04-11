class ContactPointsController < ApplicationController
  def index
    @contact_points = RequestHelper.filter_response_data(
      parliament_request.contact_points,
      'http://id.ukpds.org/schema/ContactPoint'
    )
  end

  def show
    contact_point_id = params[:contact_point_id]

    @contact_point = RequestHelper.filter_response_data(
      parliament_request.contact_points(contact_point_id),
      'http://id.ukpds.org/schema/ContactPoint'
    ).first

    vcard = create_vcard(@contact_point)
    send_data vcard.to_s, filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false }
  end
end
