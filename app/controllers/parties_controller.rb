class PartiesController < ApplicationController
  def index
    @parties = Parliament::Request.new.parties.get
  end

  def current
    @parties = Parliament::Request.new.parties.current.get
  end

  def show
    party_id = params[:party_id]
    data = Parliament::Request.new.parties(party_id).get

    @party = data.first
  end

  def members
    party_id = params[:party_id]
    data = Parliament::Request.new.parties(party_id).members.get
    @people = data.filter('http://id.ukpds.org/schema/Person')
  end

  def current_members
    party_id = params[:party_id]
    data = Parliament::Request.new.parties(party_id).members.current.get
    @people = data.filter('http://id.ukpds.org/schema/Person')
  end

  def letters
    letter = params[:letter]
    data = Parliament::Request.new.parties(letter).get

    @parties = data.filter('http://id.ukpds.org/schema/Party')
  end

  def members_letters
    letter = params[:letter]
    party_id = params[:party_id]
    data = Parliament::Request.new.parties(party_id).members(letter).get
    @party, @people = data.filter('http://id.ukpds.org/schema/Party', 'http://id.ukpds.org/schema/Person')
    @party = @party.first
  end

  def current_members_letters
    letter = params[:letter]
    party_id = params[:party_id]
    data = Parliament::Request.new.parties(party_id).members.current(letter).get
    @party, @people = data.filter('http://id.ukpds.org/schema/Party', 'http://id.ukpds.org/schema/Person')
    @party = @party.first
  end

  def lookup_by_letters
    letters = params[:letters]
    data = Parliament::Request.new.parties(letters).get

    if data.size == 1
      redirect_to party_path(data.first.graph_id) if data.size == 1
    else
      redirect_to parties_a_z_letter_path(letters)
    end
  end
end
