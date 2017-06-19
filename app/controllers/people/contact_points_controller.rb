module People
  class ContactPointsController < ApplicationController
    before_action :data_check
    
    def index
      person_id = params[:person_id]

      @person, @contact_points = RequestHelper.filter_response_data(
      parliament_request.people(person_id).contact_points,
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/ContactPoint'
      )

      @person = @person.first
    end
  end
end
