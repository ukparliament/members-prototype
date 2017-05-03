class ConstituenciesController < ApplicationController
  def index
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.a_z_letters)
    @constituencies = parliament_request.constituencies.get.sort_by(:name)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @constituency = parliament_request.constituencies.lookup(source, id).get.first

    redirect_to constituency_path(@constituency.graph_id)
  end

  def show
    @postcode = params[:postcode]
    constituency_id = params[:constituency_id]

    @constituency, @seat_incumbencies = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id),
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
    )

    @constituency = @constituency.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)

    @current_incumbency = @seat_incumbencies.shift if !@seat_incumbencies.empty? && @seat_incumbencies.first.current?

    return unless @postcode

    begin
      response = PostcodeHelper.lookup(@postcode)
      @postcode_constituency = response.filter('http://id.ukpds.org/schema/ConstituencyGroup').first
      postcode_correct = @postcode_constituency.graph_id == @constituency.graph_id
      @postcode_constituency.correct = postcode_correct
    rescue PostcodeHelper::PostcodeError => error
      flash[:error] = error.message
      @postcode = nil
    end
  end

  def current
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.current.a_z_letters)

    @constituencies = RequestHelper.filter_response_data(
      parliament_request.constituencies.current,
      'http://id.ukpds.org/schema/ConstituencyGroup'
    )

    @constituencies = @constituencies.sort_by(:name)
  end

  def map
    constituency_id = params[:constituency_id]

    @constituency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id),
      'http://id.ukpds.org/schema/ConstituencyGroup'
    ).first
  end

  def contact_point
    constituency_id = params[:constituency_id]

    @constituency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id).contact_point,
      'http://id.ukpds.org/schema/ConstituencyGroup'
    ).first
  end

  def members
    constituency_id = params[:constituency_id]

    @constituency, @seat_incumbencies = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id).members,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
    )

    @constituency = @constituency.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)
    @current_incumbency = @seat_incumbencies.shift if !@seat_incumbencies.empty? && @seat_incumbencies.first.current?
  end

  def current_member
    constituency_id = params[:constituency_id]

    @constituency, @seat_incumbency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id).members.current,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
    )

    @constituency = @constituency.first
    @seat_incumbency = @seat_incumbency.first
  end

  def letters
    letter = params[:letter]

    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.a_z_letters)

    request = parliament_request.constituencies(letter)
    response = RequestHelper.handle(request) { @constituencies = [] }

    @constituencies = response[:response].filter('http://id.ukpds.org/schema/ConstituencyGroup').sort_by(:name) if response[:success]
  end

  def current_letters
    letter = params[:letter]

    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.current.a_z_letters)

    request = parliament_request.constituencies.current(letter)
    response = RequestHelper.handle(request) { @constituencies = [] }

    @constituencies = response[:response].filter('http://id.ukpds.org/schema/ConstituencyGroup').sort_by(:name) if response[:success]
  end

  def a_to_z
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.a_z_letters)
  end

  def a_to_z_current
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.current.a_z_letters)
  end

  def lookup_by_letters
    letters = params[:letters]

    data = parliament_request.constituencies(letters).get

    if data.size == 1
      redirect_to constituency_path(data.first.graph_id)
    else
      redirect_to constituencies_a_z_letter_path(letters)
    end
  end
end
