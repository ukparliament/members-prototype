class HousesController < ApplicationController
  def index
    @houses = parliament_request.houses.get.sort_by(:name)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @house = parliament_request.houses.lookup(source, id).get.first

    redirect_to house_path(@house.graph_id)
  end

  def show
    house_id = params[:house_id]

    @house = RequestHelper.filter_response_data(
      parliament_request.houses(house_id),
      'http://id.ukpds.org/schema/House'
    ).first
  end

  def members
    house_id = params[:house_id]

    @house, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).members,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)

    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def current_members
    house_id = params[:house_id]

    @house, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).members.current,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)

    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def parties
    house_id = params[:house_id]

    @house, @parties = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
    )

    @house = @house.first
    @parties = @parties.sort_by(:name)
  end

  def current_parties
    house_id = params[:house_id]

    @house, @parties = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties.current,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
    )

    @house = @house.first
    @parties = @parties.reverse_sort_by(:member_count)
  end

  def party
    house_id = params[:house_id]
    party_id = params[:party_id]

    @house, @party = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party'
    )

    @house = @house.first
    @party = @party.first
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)

    raise ActionController::RoutingError, 'Invalid party id' if @party.nil?
  end

  def members_letters
    house_id = params[:house_id]
    letter = params[:letter]

    @house, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).members(letter),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def current_members_letters
    house_id = params[:house_id]
    letter = params[:letter]

    @house, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).members.current(letter),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
    @current_house_id, @other_house_id = HousesHelper.house_id_string(@house)
  end

  def party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )
    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members(letter),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )
    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def current_party_members
    house_id = params[:house_id]
    party_id = params[:party_id]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members.current,
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def current_party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]

    @house, @party, @people, @letters = RequestHelper.filter_response_data(
      parliament_request.houses(house_id).parties(party_id).members.current(letter),
      'http://id.ukpds.org/schema/House',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person',
      ::Grom::Node::BLANK
    )

    @house = @house.first
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = @letters.map(&:value)
    @current_person_type, @other_person_type = HousesHelper.person_type_string(@house)
  end

  def a_to_z_members
    @house_id = params[:house_id]

    @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).members.a_z_letters)
  end

  def a_to_z_current_members
    @house_id = params[:house_id]

    @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).members.current.a_z_letters)
  end

  def a_to_z_party_members
    @house_id = params[:house_id]
    @party_id = params[:party_id]

    @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).parties(@party_id).members.a_z_letters)
  end

  def a_to_z_current_party_members
    @house_id = params[:house_id]
    @party_id = params[:party_id]

    @letters = RequestHelper.process_available_letters(parliament_request.houses(@house_id).parties(@party_id).members.current.a_z_letters)
  end

  def lookup_by_letters
    letters = params[:letters]

    data = parliament_request.houses(letters).get

    if data.size == 1
      redirect_to house_path(data.first.graph_id)
    else
      redirect_to houses_path
    end
  end
end
