class HousesController < ApplicationController
  def index
    @houses = Parliament::Request.new.houses.get.sort_by(:name)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @house = Parliament::Request.new.houses.lookup.get(params: { source: source, id: id }).first

    redirect_to house_path(@house.graph_id)
  end

  def show
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).get

    @house = data.filter('http://id.ukpds.org/schema/House').first
  end

  def members
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).members.get
    letter_data = Parliament::Request.new.houses(house_id).members.a_z_letters.get

    @house, @people = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Person')
    @house = @house.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def current_members
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).members.current.get
    letter_data = Parliament::Request.new.houses(house_id).members.current.a_z_letters.get

    @house, @people = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Person')
    @house = @house.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def parties
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).parties.get

    @house, @parties = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Party')
    @house = @house.first
    @parties = @parties.sort_by(:name)
  end

  def current_parties
    house_id = params[:house_id]

    data = Parliament::Request.new.houses(house_id).parties.current.get

    @house, @parties = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Party')
    @house = @house.first
    @parties = @parties.reverse_sort_by(:member_count)
  end

  def party
    house_id = params[:house_id]
    party_id = params[:party_id]

    data = Parliament::Request.new.houses(house_id).parties(party_id).get

    @house, @party = data.filter('http://id.ukpds.org/schema/House', 'http://id.ukpds.org/schema/Party')

    @house = @house.first
    @party = @party.first
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)

    raise ActionController::RoutingError, 'Invalid party id' if @party.nil?
  end

  def members_letters
    house_id = params[:house_id]
    letter = params[:letter]

    letter_data = Parliament::Request.new.houses(house_id).members.a_z_letters.get
    @letters = letter_data.map(&:value)

    @house = Parliament::Request.new.houses(house_id).get.filter('http://id.ukpds.org/schema/House').first

    request = Parliament::Request.new.houses(house_id).members(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def current_members_letters
    house_id = params[:house_id]
    letter = params[:letter]

    letter_data = Parliament::Request.new.houses(house_id).members.current.a_z_letters.get
    @letters = letter_data.map(&:value)

    @house = Parliament::Request.new.houses(house_id).get.filter('http://id.ukpds.org/schema/House').first

    request = Parliament::Request.new.houses(house_id).members.current(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    data = Parliament::Request.new.houses(house_id).parties(party_id).members.get
    letter_data = Parliament::Request.new.houses(house_id).parties(party_id).members.a_z_letters.get

    @house, @party, @people = data.filter(
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )
    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    letter_data = Parliament::Request.new.houses(house_id).parties(party_id).members.a_z_letters.get
    @letters = letter_data.map(&:value)

    @house = Parliament::Request.new.houses(house_id).get.filter('http://id.ukpds.org/schema/House').first
    @party = Parliament::Request.new.parties(party_id).get.filter('http://id.ukpds.org/schema/Party').first

    request = Parliament::Request.new.houses(house_id).parties(party_id).members(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def current_party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    data = Parliament::Request.new.houses(house_id).parties(party_id).members.current.get
    letter_data = Parliament::Request.new.houses(house_id).parties(party_id).members.current.a_z_letters.get

    @house, @party, @people = data.filter(
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )

    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def current_party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    letter_data = Parliament::Request.new.houses(house_id).parties(party_id).members.current.a_z_letters.get
    @letters = letter_data.map(&:value)

    @house = Parliament::Request.new.houses(house_id).get.filter('http://id.ukpds.org/schema/House').first
    @party = Parliament::Request.new.parties(party_id).get.filter('http://id.ukpds.org/schema/Party').first

    request = Parliament::Request.new.houses(house_id).parties(party_id).members.current(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def a_to_z_members
    @house_id = params[:house_id]

    letter_data = Parliament::Request.new.houses(@house_id).members.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_current_members
    @house_id = params[:house_id]

    letter_data = Parliament::Request.new.houses(@house_id).members.current.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_party_members
    @house_id = params[:house_id]
    @party_id = params[:party_id]

    letter_data = Parliament::Request.new.houses(@house_id).parties(@party_id).members.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_current_party_members
    @house_id = params[:house_id]
    @party_id = params[:party_id]

    letter_data = Parliament::Request.new.houses(@house_id).parties(@party_id).members.current.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def lookup_by_letters
    letters = params[:letters]

    data = Parliament::Request.new.houses(letters).get

    if data.size == 1
      redirect_to house_path(data.first.graph_id)
    else
      redirect_to houses_path
    end
  end
end
