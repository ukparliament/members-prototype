class PeopleController < ApplicationController
  def index
    @people = Parliament::Request.new.people.get
  end

  def show
    person_id = params[:person_id]

    data = Parliament::Request.new.people(person_id).get

    @person = data.filter('http://id.ukpds.org/schema/Person').first

    @current_seat_incumbency = @person.seat_incumbencies.select(&:current?).first
    @current_party_membership = @person.party_memberships.select(&:current?).first
  end

  def members
    data = Parliament::Request.new.people.members.get

    @people = data.filter('http://id.ukpds.org/schema/Person')
  end

  def current_members
    data = Parliament::Request.new.people.members.current.get

    @people = data.filter('http://id.ukpds.org/schema/Person')
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

    @person, @parties = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/Party')
    @person = @person.first
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

    @person, @constituencies = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/ConstituencyGroup')
    @person = @person.first
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

    @person, @houses = data.filter('http://id.ukpds.org/schema/Person', 'http://id.ukpds.org/schema/House')
    @person = @person.first
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

    @people = Parliament::Request.new.people(letter).get
  end

  def members_letters
    letter = params[:letter]

    data = Parliament::Request.new.people.members(letter).get

    @people = data.filter('http://id.ukpds.org/schema/Person')
  end

  def current_members_letters
    letter = params[:letter]

    data = Parliament::Request.new.people.members.current(letter).get

    @people = data.filter('http://id.ukpds.org/schema/Person')
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
