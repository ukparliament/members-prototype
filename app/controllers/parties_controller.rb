class PartiesController < ApplicationController
  def index
    letter_data = parliament_request.parties.a_z_letters.get

    @parties = parliament_request.parties.get.sort_by(:name)
    @letters = letter_data.map(&:value)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @party = parliament_request.parties.lookup(source, id).get.first

    redirect_to party_path(@party.graph_id)
  end

  def current
    @parties = parliament_request.parties.current.get.sort_by(:name)
  end

  def show
    party_id = params[:party_id]

    data = parliament_request.parties(party_id).get

    @party = data.first
  end

  def members
    party_id = params[:party_id]

    data = parliament_request.parties(party_id).members.get
    letter_data = parliament_request.parties(party_id).members.a_z_letters.get

    @party, @people = data.filter('http://id.ukpds.org/schema/Party', 'http://id.ukpds.org/schema/Person')
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def current_members
    party_id = params[:party_id]

    data = parliament_request.parties(party_id).members.current.get
    letter_data = parliament_request.parties(party_id).members.current.a_z_letters.get

    @party, @people = data.filter('http://id.ukpds.org/schema/Party', 'http://id.ukpds.org/schema/Person')
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def letters
    letter = params[:letter]

    letter_data = parliament_request.parties.a_z_letters.get
    @letters = letter_data.map(&:value)

    request = parliament_request.parties(letter)
    response = RequestHelper.handler(request) { @parties = [] }

    @parties = response[:response].filter('http://id.ukpds.org/schema/Party').sort_by(:name) if response[:success]
  end

  def members_letters
    letter = params[:letter]
    party_id = params[:party_id]

    letter_data = parliament_request.parties(party_id).members.a_z_letters.get
    @letters = letter_data.map(&:value)

    @party = parliament_request.parties(party_id).get.filter('http://id.ukpds.org/schema/Party').first

    request = parliament_request.parties(party_id).members(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def current_members_letters
    letter = params[:letter]
    party_id = params[:party_id]

    letter_data = parliament_request.parties(party_id).members.current.a_z_letters.get
    @letters = letter_data.map(&:value)

    @party = parliament_request.parties(party_id).get.filter('http://id.ukpds.org/schema/Party').first

    request = parliament_request.parties(party_id).members.current(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def a_to_z
    letter_data = parliament_request.parties.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_members
    @party_id = params[:party_id]

    letter_data = parliament_request.parties(@party_id).members.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_current_members
    @party_id = params[:party_id]

    letter_data = parliament_request.parties(@party_id).members.current.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def lookup_by_letters
    letters = params[:letters]
    data = parliament_request.parties(letters).get

    if data.size == 1
      redirect_to party_path(data.first.graph_id)
    else
      redirect_to parties_a_z_letter_path(letters)
    end
  end
end
