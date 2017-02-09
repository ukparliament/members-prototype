class PeopleController < ApplicationController
  def index
    @people = Parliament::Request.new.people.get
  end

  def show
    person_id = params[:id]
    data = Parliament::Request.new.people(person_id).get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
  end

  def members
    data = Parliament::Request.new.people.members.get
    @people = data.filter('http://id.ukpds.org/schema/Person').first

    render 'index'
  end

  def current_members
    data = Parliament::Request.new.people.members.current.get
    @people = data.filter('http://id.ukpds.org/schema/Person').first
  end

  def contact_points
    person_id = params[:person_id]
    data = Parliament::Request.new.people(person_id).contact_points.get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
    @contact_points = data.filter('http://id.ukpds.org/schema/ContactPoint').first
  end

  def parties
    person_id = params[:person_id]
    data = Parliament::Request.new.people(person_id).parties.get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
    @parties = data.filter('http://id.ukpds.org/schema/Party').first
  end

  def current_party
    person_id = params[:person_id]
    data = Parliament::Request.new.people(person_id).parties.current.get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
    @party = data.filter('http://id.ukpds.org/schema/Party').first.first
  end

  def constituencies
    person_id = params[:person_id]
    data = Parliament::Request.new.people(person_id).constituencies.get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
    @constituencies = data.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
  end

  def current_constituency
    person_id = params[:person_id]
    data = Parliament::Request.new.people(person_id).constituencies.current.get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
    @constituency = data.filter('http://id.ukpds.org/schema/ConstituencyGroup').first.first
  end

  def houses
    person_id = params[:person_id]
    data = Parliament::Request.new.people(person_id).houses.get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
    @houses = data.filter('http://id.ukpds.org/schema/House').first
  end

  def current_house
    person_id = params[:person_id]
    data = Parliament::Request.new.people(person_id).houses.current.get
    @person = data.filter('http://id.ukpds.org/schema/Person').first.first
    @house = data.filter('http://id.ukpds.org/schema/House').first.first
  end

  def letters
    letter = params[:letter]
    @people = Parliament::Request.new.people(letter).get

    render 'index'
  end

  def members_letters
    letter = params[:letter]
    data = Parliament::Request.new.people.members(letter).get
    @people = data.filter('http://id.ukpds.org/schema/Person').first

    render 'index'
  end

  def current_members_letters
    letter = params[:letter]
    data = Parliament::Request.new.people.members.current(letter).get
    @people = data.filter('http://id.ukpds.org/schema/Person').first

    render 'current_members'
  end
end
