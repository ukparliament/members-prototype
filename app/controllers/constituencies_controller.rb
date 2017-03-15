class ConstituenciesController < ApplicationController
  def index
    letter_data = Parliament::Request.new.constituencies.a_z_letters.get

    @constituencies = Parliament::Request.new.constituencies.get.sort_by(:name)
    @letters = letter_data.map(&:value)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @constituency = Parliament::Request.new.constituencies.lookup.get(params: { source: source, id: id }).first

    redirect_to constituency_path(@constituency.graph_id)
  end

  def show
    constituency_id = params[:constituency_id]

    data = Parliament::Request.new.constituencies(constituency_id).get

    @constituency, @seat_incumbencies = data.filter(
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
    )
    @constituency = @constituency.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)

    if @seat_incumbencies.size > 0 && @seat_incumbencies.first.current?
        @current_incumbency = @seat_incumbencies.shift
    end
  end

  def current
    letter_data = Parliament::Request.new.constituencies.current.a_z_letters.get

    data = Parliament::Request.new.constituencies.current.get

    @constituencies = data.filter('http://id.ukpds.org/schema/ConstituencyGroup')
    @constituencies = @constituencies.sort_by(:name)
    @letters = letter_data.map(&:value)
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

    @constituency, @seat_incumbencies = data.filter(
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
    )
    @constituency = @constituency.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)
  end

  def current_member
    constituency_id = params[:constituency_id]

    data = Parliament::Request.new.constituencies(constituency_id).members.current.get

    @constituency, @seat_incumbency = data.filter(
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
    )
    @constituency = @constituency.first
    @seat_incumbency = @seat_incumbency.first
  end

  def letters
    letter = params[:letter]

    letter_data = Parliament::Request.new.constituencies.a_z_letters.get

    @constituencies = Parliament::Request.new.constituencies(letter).get.sort_by(:name)
    @letters = letter_data.map(&:value)
  end

  def current_letters
    letter = params[:letter]

    letter_data = Parliament::Request.new.constituencies.current.a_z_letters.get
    data = Parliament::Request.new.constituencies.current(letter).get

    @constituencies = data.filter('http://id.ukpds.org/schema/ConstituencyGroup')
    @constituencies = @constituencies.sort_by(:name)
    @letters = letter_data.map(&:value)
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
