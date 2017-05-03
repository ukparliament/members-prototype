class PartiesController < ApplicationController
  def index
    @parties = parliament_request.parties.get.sort_by(:name)
    @letters = RequestHelper.process_available_letters(parliament_request.parties.a_z_letters)
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

    @party, @people = RequestHelper.filter_response_data(
      parliament_request.parties(party_id).members,
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )

    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = RequestHelper.process_available_letters(parliament_request.parties(party_id).members.a_z_letters)
  end

  def current_members
    party_id = params[:party_id]

    @party, @people = RequestHelper.filter_response_data(
      parliament_request.parties(party_id).members.current,
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )

    @party = @party.first
    @people = @people.sort_by(:sort_name)
    @letters = RequestHelper.process_available_letters(parliament_request.parties(party_id).members.current.a_z_letters)
  end

  def letters
    letter = params[:letter]

    request = parliament_request.parties(letter)
    response = RequestHelper.handle(request) { @parties = [] }

    @parties = response[:response].filter('http://id.ukpds.org/schema/Party').sort_by(:name) if response[:success]
    @letters = RequestHelper.process_available_letters(parliament_request.parties.a_z_letters)
  end

  def members_letters
    letter = params[:letter]
    party_id = params[:party_id]

    @party = RequestHelper.filter_response_data(
      parliament_request.parties(party_id),
      'http://id.ukpds.org/schema/Party'
    ).first

    request = parliament_request.parties(party_id).members(letter)
    response = RequestHelper.handle(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]
    @letters = RequestHelper.process_available_letters(parliament_request.parties(party_id).members.a_z_letters)
  end

  def current_members_letters
    letter = params[:letter]
    party_id = params[:party_id]

    @party = RequestHelper.filter_response_data(
      parliament_request.parties(party_id),
      'http://id.ukpds.org/schema/Party'
    ).first

    request = parliament_request.parties(party_id).members.current(letter)
    response = RequestHelper.handle(request) { @people = [] }

    @people = response[:response].filter('http://id.ukpds.org/schema/Person').sort_by(:sort_name) if response[:success]

    @letters = RequestHelper.process_available_letters(parliament_request.parties(party_id).members.current.a_z_letters)
  end

  def a_to_z
    @letters = RequestHelper.process_available_letters(parliament_request.parties.a_z_letters)
  end

  def a_to_z_members
    @party_id = params[:party_id]

    @letters = RequestHelper.process_available_letters(parliament_request.parties(@party_id).members.a_z_letters)
  end

  def a_to_z_current_members
    @party_id = params[:party_id]

    @letters = RequestHelper.process_available_letters(parliament_request.parties(@party_id).members.current.a_z_letters)
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
