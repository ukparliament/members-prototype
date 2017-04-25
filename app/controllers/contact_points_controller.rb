class ContactPointsController < ApplicationController
  def index
    data = parliament_request.contact_points.get
    @contact_points = data.filter('http://id.ukpds.org/schema/ContactPoint')
  end

  def show
    contact_point_id = params[:contact_point_id]
    data = parliament_request.contact_points(contact_point_id).get
    @contact_point = data.filter('http://id.ukpds.org/schema/ContactPoint').first
    vcard = create_vcard(@contact_point)
    send_data vcard.to_s, filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false }
  end
end
