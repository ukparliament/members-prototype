class PartiesController < ApplicationController
  def index
    @parties = Parliament::Request.new.parties.get
  end

  def current
    @parties = Parliament::Request.new.parties.current.get
  end

  def show
    id = params[:id]
    begin
      data = Parliament::Request.new.parties(id).get
    rescue NoMethodError => e
      Rails.logger.error(e)

      raise ActionController::RoutingError.new('Not Found')
    end
    @party = data.first
  end

  def members
    party_id = params[:party_id]
    begin
      data = Parliament::Request.new.parties(party_id).members.get
    rescue NoMethodError => e
      Rails.logger.error(e)

      raise ActionController::RoutingError.new('Not Found')
    end
    @people = data.filter('http://id.ukpds.org/schema/Person').first
  end

  def current_members
    party_id = params[:party_id]
    begin
      data = Parliament::Request.new.parties(party_id).members.current.get
    rescue NoMethodError => e
      Rails.logger.error(e)

      raise ActionController::RoutingError.new('Not Found')
    end
    @people = data.filter('http://id.ukpds.org/schema/Person').first

  end

  def letters
    letter = params[:letter]
    begin
      data = Parliament::Request.new.parties(letter).get
    rescue NoMethodError => e
      Rails.logger.error(e)

      raise ActionController::RoutingError.new('Not Found')
    end
    @party = data.first
  end

  def members_letters
    letter = params[:letter]
    party_id = params[:party_id]
    begin
     data_party = Parliament::Request.new.parties(party_id).get
     data_members = Parliament::Request.new.parties(party_id).members(letter).get
    rescue NoMethodError => e
      Rails.logger.error(e)

      raise ActionController::RoutingError.new('Not Found')
    end
    @party = data_party.first
    @people = data_members.filter('http://id.ukpds.org/schema/Person').first
  end

  def current_members_letters
    letter = params[:letter]
    party_id = params[:party_id]
    begin
      data_party = Parliament::Request.new.parties(party_id).get
      data_current_members = Parliament::Request.new.parties(party_id).members.current(letter).get
    rescue NoMethodError => e
      Rails.logger.error(e)

      raise ActionController::RoutingError.new('Not Found')
    end
    @party = data_party.first
    @people = data_current_members.filter('http://id.ukpds.org/schema/Person').first
  end
end
