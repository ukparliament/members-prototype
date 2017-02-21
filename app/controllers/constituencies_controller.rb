class ConstituenciesController < ApplicationController
  def index
    @constituencies = Parliament::Request.new.constituencies.get
  end

  def show
    constituency_id = params[:constituency_id]
    data = Parliament::Request.new.constituencies(constituency_id).get
    @constituency = data.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
  end

  def current
    @constituencies = Parliament::Request.new.constituencies.current.get
  end

  def map
    constituency_id = params[:constituency_id]
    data = Parliament::Request.new.constituencies(constituency_id).get
    @constituency = data.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
  end

  def contact_point
    constituency_id = params[:constituency_id]
    data = Parliament::Request.new.constituencies(constituency_id).contact_point.get
    @constituency = data.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
  end

  def members
    constituency_id = params[:constituency_id]
    data = Parliament::Request.new.constituencies(constituency_id).members.get
    @constituency = data.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
  end

  def current_member
    constituency_id = params[:constituency_id]
    data = Parliament::Request.new.constituencies(constituency_id).members.current.get
    @constituency = data.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
  end

  def letters
    letter = params[:letter]
    @constituencies = Parliament::Request.new.constituencies(letter).get
  end

  def current_letters
    letter = params[:letter]
    @constituencies = Parliament::Request.new.constituencies.current(letter).get
  end

  def lookup_by_letters
    letters = params[:letters]
    data = Parliament::Request.new.constituencies(letters).get

    if data.size == 1
      redirect_to constituency_path(data.first.graph_id)
    else
      redirect_to constituencies_a_z_letter_path(letters)
    end
  end
end
