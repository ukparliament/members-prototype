class PeopleController < ApplicationController
  def index
    letter_data = parliament_request.people.a_z_letters.get

    @people = parliament_request.people.get.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @person = parliament_request.people.lookup(source, id).get.first

    redirect_to person_path(@person.graph_id)
  end

  def show
    @postcode = params[:postcode]
    person_id = params[:person_id]

    data = parliament_request.people(person_id).get

    @person, @seat_incumbencies, @house_incumbencies = data.filter(
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

    return unless @postcode

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

  def members
    data = parliament_request.people.members.get
    letter_data = parliament_request.people.members.a_z_letters.get

    @people = data.filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def current_members
    data = parliament_request.people.members.current.get
    letter_data = parliament_request.people.members.current.a_z_letters.get

    @people = data.filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def contact_points
    person_id = params[:person_id]

    data = parliament_request.people(person_id).contact_points.get

    @person, @contact_points = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/ContactPoint')
    @person = @person.first
  end

  def parties
    person_id = params[:person_id]

    data = parliament_request.people(person_id).parties.get

    @person, @party_memberships = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/PartyMembership')
    @person = @person.first
    @party_memberships = @party_memberships.reverse_sort_by(:start_date)
  end

  def current_party
    person_id = params[:person_id]

    data = parliament_request.people(person_id).parties.current.get

    @person, @party = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/Party')
    @person = @person.first
    @party = @party.first
  end

  def constituencies
    person_id = params[:person_id]

    data = parliament_request.people(person_id).constituencies.get

    @person, @seat_incumbencies = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/SeatIncumbency')
    @person = @person.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)
  end

  def current_constituency
    person_id = params[:person_id]

    data = parliament_request.people(person_id).constituencies.current.get

    @person, @constituency = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/ConstituencyGroup')
    @person = @person.first
    @constituency = @constituency.first
  end

  def houses
    person_id = params[:person_id]

    data = parliament_request.people(person_id).houses.get

    @person, @incumbencies = data.filter(
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/Incumbency'
    )
    @person = @person.first
    @incumbencies = @incumbencies.reverse_sort_by(:start_date)
  end

  def current_house
    person_id = params[:person_id]

    data = parliament_request.people(person_id).houses.current.get

    @person, @house = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/House')
    @person = @person.first
    @house = @house.first
  end

  def letters
    letter = params[:letter]

    letter_data = parliament_request.people.a_z_letters.get

    @letters = letter_data.map(&:value)

    request = parliament_request.people(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].sort_by(:sort_name) if response[:success]
  end

  def members_letters
    letter = params[:letter]

    letter_data = parliament_request.people.members.a_z_letters.get

    @letters = letter_data.map(&:value)

    request = parliament_request.people.members(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def current_members_letters
    letter = params[:letter]

    letter_data = parliament_request.people.members.current.a_z_letters.get

    @letters = letter_data.map(&:value)

    request = parliament_request.people.members.current(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def a_to_z
    letter_data = parliament_request.people.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_members
    letter_data = parliament_request.people.members.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_current_members
    letter_data = parliament_request.people.members.current.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def lookup_by_letters
    letters = params[:letters]

    data = parliament_request.people(letters).get

    if data.size == 1
      redirect_to person_path(data.first.graph_id)
    else
      redirect_to people_a_z_letter_path(letters)
    end
  end
end
