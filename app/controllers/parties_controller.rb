class PartiesController < ApplicationController
  def index
    letter_data = Parliament::Request.new.parties.a_z_letters.get

    @parties = Parliament::Request.new.parties.get.sort_by(:name)
    @letters = letter_data.map(&:value)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @party = Parliament::Request.new.parties.lookup.get(params: { source: source, id: id }).first

    redirect_to party_path(@party.graph_id)
  end

  def current
    @parties = Parliament::Request.new.parties.current.get.sort_by(:name)
  end

  def show
    party_id = params[:party_id]

    data = Parliament::Request.new.parties(party_id).get

    @party = data.first
  end

  def members
    party_id = params[:party_id]

    data = Parliament::Request.new.parties(party_id).members.get
    letter_data = Parliament::Request.new.parties(party_id).members.a_z_letters.get

    @party, @people = data.filter('http://id.ukpds.org/schema/Party', 'http://id.ukpds.org/schema/Person')
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def current_members
    party_id = params[:party_id]

    data = Parliament::Request.new.parties(party_id).members.current.get
    letter_data = Parliament::Request.new.parties(party_id).members.current.a_z_letters.get

    @party, @people = data.filter('http://id.ukpds.org/schema/Party', 'http://id.ukpds.org/schema/Person')
    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = letter_data.map(&:value)
  end

  def letters
    letter = params[:letter]

    letter_data = Parliament::Request.new.parties.a_z_letters.get
    @letters = letter_data.map(&:value)

    request = Parliament::Request.new.parties(letter)
    response = RequestHelper.handler(request) { @parties = [] }

    @parties = response[:response].filter('http://id.ukpds.org/schema/Party').sort_by(:name) if response[:success]
  end

  def members_letters
    letter = params[:letter]
    party_id = params[:party_id]

    letter_data = Parliament::Request.new.parties(party_id).members.a_z_letters.get
    @letters = letter_data.map(&:value)

    @party = Parliament::Request.new.parties(party_id).get.filter('http://id.ukpds.org/schema/Party').first

    request = Parliament::Request.new.parties(party_id).members(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def current_members_letters
    letter = params[:letter]
    party_id = params[:party_id]

    letter_data = Parliament::Request.new.parties(party_id).members.current.a_z_letters.get
    @letters = letter_data.map(&:value)

    @party = Parliament::Request.new.parties(party_id).get.filter('http://id.ukpds.org/schema/Party').first

    request = Parliament::Request.new.parties(party_id).members.current(letter)
    response = RequestHelper.handler(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
  end

  def a_to_z
    letter_data = Parliament::Request.new.parties.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_members
    @party_id = params[:party_id]

    letter_data = Parliament::Request.new.parties(@party_id).members.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def a_to_z_current_members
    @party_id = params[:party_id]

    letter_data = Parliament::Request.new.parties(@party_id).members.current.a_z_letters.get

    @letters = letter_data.map(&:value)
  end

  def lookup_by_letters
    letters = params[:letters]
    data = Parliament::Request.new.parties(letters).get

    if data.size == 1
      redirect_to party_path(data.first.graph_id)
    else
      redirect_to parties_a_z_letter_path(letters)
    end
  end
end
