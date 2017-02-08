class ContactPointsController < ApplicationController

  def index
    data = Parliament::Request.new.contact_points.get
    @contact_points = data.filter('http://id.ukpds.org/schema/ContactPoint').first
  end

  def show
    # @contact_point = ContactPoint.find(params[:id]) or not_found
    # vcard = create_vcard(@contact_point)
    # send_data vcard.to_s, filename: "contact.vcf", disposition: 'attachment', data: { turbolink: false }
  end
end
