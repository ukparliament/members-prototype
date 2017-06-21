class PeopleController < ApplicationController
  before_action :data_check

  def index
    @people, @letters = RequestHelper.filter_response_data(
      parliament_request.people,
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
  end

  def show
    @postcode = flash[:postcode]
    person_id = params[:person_id]

    @person, @seat_incumbencies, @house_incumbencies = RequestHelper.filter_response_data(
      parliament_request.people(person_id),
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/SeatIncumbency',
      'http://id.ukpds.org/schema/HouseIncumbency'
    )

    @person = @person.first

    @current_party_membership = @person.party_memberships.select(&:current?).first

    sorted_incumbencies = Parliament::NTriple::Utils.sort_by({
      list:             @person.incumbencies,
      parameters:       [:end_date],
      prepend_rejected: false
      })

    @most_recent_incumbency = sorted_incumbencies.last
    @current_incumbency = @most_recent_incumbency && @most_recent_incumbency.current? ? @most_recent_incumbency : nil

    return unless @postcode && @current_incumbency

    begin
      response = PostcodeHelper.lookup(@postcode)
      @postcode_constituency = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
      postcode_correct = @postcode_constituency.graph_id == @current_incumbency.constituency.graph_id
      @postcode_constituency.correct = postcode_correct
    rescue PostcodeHelper::PostcodeError => error
      flash[:error] = error.message
      @postcode = nil
    end
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @person = parliament_request.people.lookup(source, id).get.first

    redirect_to person_path(@person.graph_id)
  end

  def postcode_lookup
    flash[:postcode] = params[:postcode]

    redirect_to person_path(params[:person_id])
  end

  def letters
    letter = params[:letter]

    @people, @letters = RequestHelper.filter_response_data(
      parliament_request.people(letter),
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
  end

  def a_to_z
    @letters = RequestHelper.process_available_letters(parliament_request.people.a_z_letters)
  end

  def lookup_by_letters
    letters = params[:letters]

    @people, @letters = RequestHelper.filter_response_data(
      parliament_request.people.partial(letters),
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    if @people.size == 1
      redirect_to person_path(@people.first.graph_id)
      return
    end

    @people = @people.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  private

  # What to do about postcode_lookup?
  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.people },
    show: proc { |params| ParliamentHelper.parliament_request.people(params[:person_id]) },
    lookup: proc { |params| ParliamentHelper.parliament_request.people.lookup(params[:source], params[:id]) },
    letters: proc { |params| ParliamentHelper.parliament_request.people(params[:letter]) },
    a_to_z: proc { ParliamentHelper.parliament_request.people.a_z_letters },
    lookup_by_letters: proc { |params| ParliamentHelper.parliament_request.people.partial(params[:letters]) }
  }.freeze

  def data_url
    ROUTE_MAP[params[:action].to_sym]
  end
end
