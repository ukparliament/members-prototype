class PeopleController < ApplicationController
  def index
    letter_data = Parliament::Request.new.people.a_z_letters.get

    @people = Parliament::Request.new.people.get.sort_by(:family_name, :given_name)
    @letters = letter_data.map(&:value)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @person = Parliament::Request.new.people.lookup.get(params: { source: source, id: id }).first

    redirect_to person_path(@person.graph_id)
  end

  def show
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).get

    @person, @seat_incumbencies, @house_incumbencies = data.filter(
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/SeatIncumbency',
      'http://id.ukpds.org/schema/HouseIncumbency'
    )

    @person = @person.first
    @current_incumbency = @seat_incumbencies.select(&:current?).first || @house_incumbencies.select(&:current?).first
    @current_party_membership = @person.party_memberships.select(&:current?).first

    if @current_incumbency.nil?
      incumbencies = @seat_incumbencies.nodes.dup.concat(@house_incumbencies.nodes)
      @most_recent_incumbency = incumbencies.sort_by(&:end_date).last
    else
      @most_recent_incumbency = @current_incumbency
    end
  end

  def members
    data = Parliament::Request.new.people.members.get
    letter_data = Parliament::Request.new.people.members.a_z_letters.get

    @people = data.filter('http://id.ukpds.org/schema/Person').sort_by(:family_name, :given_name)
    @letters = letter_data.map(&:value)
  end

  def current_members
    data = Parliament::Request.new.people.members.current.get
    letter_data = Parliament::Request.new.people.members.current.a_z_letters.get

    @people = data.filter('http://id.ukpds.org/schema/Person').sort_by(:family_name, :given_name)
    @letters = letter_data.map(&:value)
  end

  def contact_points
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).contact_points.get

    @person, @contact_points = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/ContactPoint')
    @person = @person.first
  end

  def parties
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).parties.get

    @person, @party_memberships = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/PartyMembership')
    @person = @person.first
    @party_memberships = @party_memberships.reverse_sort_by(:start_date)
  end

  def current_party
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).parties.current.get

    @person, @party = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/Party')
    @person = @person.first
    @party = @party.first
  end

  def constituencies
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).constituencies.get

    @person, @seat_incumbencies = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/SeatIncumbency')
    @person = @person.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)
  end

  def current_constituency
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).constituencies.current.get

    @person, @constituency = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/ConstituencyGroup')
    @person = @person.first
    @constituency = @constituency.first
  end

  def houses
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).houses.get

    @person, @incumbencies = data.filter(
      'http://id.ukpds.org/schema/Person',
      'http://id.ukpds.org/schema/Incumbency'
    )
    @person = @person.first
    @incumbencies = @incumbencies.reverse_sort_by(:start_date)
  end

  def current_house
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).houses.current.get

    @person, @house = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/House')
    @person = @person.first
    @house = @house.first
  end

  def letters
    letter = params[:letter]

    letter_data = Parliament::Request.new.people.a_z_letters.get

    @people = Parliament::Request.new.people(letter).get.sort_by(:family_name, :given_name)
    @letters = letter_data.map(&:value)
  end

  def members_letters
    letter = params[:letter]

    data = Parliament::Request.new.people.members(letter).get
    letter_data = Parliament::Request.new.people.members.a_z_letters.get

    @people = data.filter('http://id.ukpds.org/schema/Person').sort_by(:family_name, :given_name)
    @letters = letter_data.map(&:value)
  end

  def current_members_letters
    letter = params[:letter]

    data = Parliament::Request.new.people.members.current(letter).get
    letter_data = Parliament::Request.new.people.members.current.a_z_letters.get

    @people = data.filter('http://id.ukpds.org/schema/Person').sort_by(:family_name, :given_name)
    @letters = letter_data.map(&:value)
  end

  def lookup_by_letters
    letters = params[:letters]

    data = Parliament::Request.new.people(letters).get

    if data.size == 1
      redirect_to person_path(data.first.graph_id)
    else
      redirect_to people_a_z_letter_path(letters)
    end
  end
end
