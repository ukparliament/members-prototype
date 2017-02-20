class HousesController < ApplicationController
  def index
    @houses = Parliament::Request.new.houses.get
  end

  def show
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).get

    @house = data.filter('http://id.ukpds.org/schema/House').first
  end

  def members
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).members.get

    @house, @people = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Person')
    @house = @house.first
  end

  def current_members
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).members.current.get

    @house, @people = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Person')
    @house = @house.first
  end

  def parties
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).parties.get

    @house, @parties = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Party')
    @house = @house.first
  end

  def current_parties
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).parties.current.get

    @house, @parties = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Party')
    @house = @house.first
  end

  def party
    house_id = params[:house_id]
    party_id = params[:party_id]

    data = Parliament::Request.new.houses(house_id).parties(party_id).get

    @house, @party = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Party')
    @house = @house.first
    @party = @party.first
  end

  def members_letters
    house_id = params[:house_id]
    letter = params[:letter]

    data = Parliament::Request.new.houses(house_id).members(letter).get

    @house, @people = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Person')
    @house = @house.first
  end

  def current_members_letters
    house_id = params[:house_id]
    letter = params[:letter]

    data = Parliament::Request.new.houses(house_id).members.current(letter).get

    @house, @people = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Person')
    @house = @house.first
  end

  def party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    data = Parliament::Request.new.houses(house_id).parties(party_id).members.get

    @house, @party, @people = data.filter(
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )
    @house = @house.first
    @party = @party.first
  end

  def party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    data = Parliament::Request.new.houses(house_id).parties(party_id).members(letter).get

    @house, @party, @people = data.filter(
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )
    @house = @house.first
    @party = @party.first
  end

  def current_party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    data = Parliament::Request.new.houses(house_id).parties(party_id).members.current.get

    @house, @party, @people = data.filter(
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )

    @house = @house.first
    @party = @party.first
  end

  def current_party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    data = Parliament::Request.new.houses(house_id).parties(party_id).members.current(letter).get

    @house, @party, @people = data.filter(
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )

    @house = @house.first
    @party = @party.first
  end

  def lookup_by_letters
    letters = params[:letters]

    data = Parliament::Request.new.houses(letters).get

    if data.size == 1
      redirect_to house_path(data.first.graph_id) if data.size == 1
    else
      redirect_to houses_path
    end
  end
end
