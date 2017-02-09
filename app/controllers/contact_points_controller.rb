class ContactPointsController < ApplicationController

  def index
    # @contact_points = ContactPoint.all
    #
    # format({ serialized_data: @contact_points })
  end

  def show
    # @contact_point = ContactPoint.find(params[:id]) or not_found
    # vcard = create_vcard(@contact_point)
    # send_data vcard.to_s, filename: "contact.vcf", disposition: 'attachment', data: { turbolink: false }
  end
end
