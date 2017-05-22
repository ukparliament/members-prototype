class ConstituenciesController < ApplicationController
  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view
  # @controller_action_param :name [String] the name of the constituency
  # @return [Array] array of letters which are first letters of constituencies
  def index
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.a_z_letters)
    @constituencies = parliament_request.constituencies.get.sort_by(:name)
  end

  # Renders a single constituency given an external source and an id that identifies this constituency in this source
  # @controller_action_param :source [String] external source mnisId (MNIS system)
  # @controller_action_param :id [String] mnis id that identifies constituency in MNIS
  # @return [Grom::Node] a single constituency that redirects to /constituencies/:constituency
  def lookup
    source = params[:source]
    id = params[:id]

    @constituency = parliament_request.constituencies.lookup(source, id).get.first

    redirect_to constituency_path(@constituency.graph_id)
  end

  # Renders a single constituency given a constituency id
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database
  # @controller_action_param :postcode [String] postcode entered into search box on beta.parliament.uk/postcodes and if invalid displays an error message
  # @return [Grom::Node] a single constituency
  def show
    constituency_id = params[:constituency_id]
    @postcode = flash[:postcode]

    @constituency, @seat_incumbencies = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id),
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency'
    )

    @constituency = @constituency.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)

    @current_incumbency = @seat_incumbencies.shift if !@seat_incumbencies.empty? && @seat_incumbencies.first.current?

    return if @postcode.nil?

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

  # Renders a constituency object if postcode valid
  # @controller_action_param :postcode [String] postcode entered into search box on beta.parliament.uk/postcodes and if invalid displays an error message:
  # 'We couldn't find the postcode you entered'
  # Triggers constituency#show action given constituency id resolved from successful postcode lookup request from ordnance survey sparql endpoint
  # Successful resolution from ordance survey returns longitude, latitude of postcode which maps to constituency in graph database
  # @return [Grom::Node] a single constituency
  def postcode_lookup
    flash[:postcode] = params[:postcode]

    redirect_to constituency_path(params[:constituency_id])
  end


  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view

  def current
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.current.a_z_letters)

    @constituencies = RequestHelper.filter_response_data(
      parliament_request.constituencies.current,
      'http://id.ukpds.org/schema/ConstituencyGroup'
    )

    @constituencies = @constituencies.sort_by(:name)
  end

  # Renders a constituency that has a constituency area object on map view given a constituency id
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database
  # @return [Grom::Node] a single constituency that has a constituency area object which holds a geo polygon
  def map
    constituency_id = params[:constituency_id]

    @constituency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id),
      'http://id.ukpds.org/schema/ConstituencyGroup'
    ).first
  end

  # Renders a contact point given a constituency id
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database
  # @return [Grom::Node] a single constituency that has a contact point object
  def contact_point
    constituency_id = params[:constituency_id]

    @constituency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id).contact_point,
      'http://id.ukpds.org/schema/ConstituencyGroup'
    ).first
  end

  # Renders a list of seat incumbents in reverse chronological start date order, given a constituency id, with current seat incumbent listed at the top
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database
  # @return [Array<Grom::Node] seat_incumbencies, [Grom::Node] constituency
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

  # Renders a constituency, current incumbent given a constituency id
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database
  # @return [Grom::Node] seat_incumbency, [Grom::Node] constituency
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

  # Renders a list of constituencies that begin with a particular letter given the letter. Shown with an a - z partial view
  # @controller_action_param :letter [String] single letter that is case insensitive
  # @return [Array<Grom::Node] constituencies
  def letters
    letter = params[:letter]

    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.a_z_letters)

    request = parliament_request.constituencies(letter)
    response = RequestHelper.handle(request) { @constituencies = [] }

    @constituencies = response[:response].filter('http://id.ukpds.org/schema/ConstituencyGroup').sort_by(:name) if response[:success]
  end

  # Renders a list of current constituencies that begin with a particular letter given the letter. Shown with an a - z partial view
  # @controller_action_param :letter [String] single letter that is case insensitive
  # @return [Array<Grom::Node] constituencies
  def current_letters
    letter = params[:letter]

    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.current.a_z_letters)

    request = parliament_request.constituencies.current(letter)
    response = RequestHelper.handle(request) { @constituencies = [] }

    @constituencies = response[:response].filter('http://id.ukpds.org/schema/ConstituencyGroup').sort_by(:name) if response[:success]
  end

  # Renders a list of letters taken from first letter of all constituencies. Shown with an a - z partial view
  def a_to_z
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.a_z_letters)
  end

  # Renders a list of letters taken from first letter of all current constituencies. Shown with an a - z partial view
  def a_to_z_current
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.current.a_z_letters)
  end

  # Renders a list of constituencies given a set of letters
  # @controller_action_param :letters [String], set of letters that are case insensitive
  # @return [Grom::Node] constituency redirects to /constituencies/:constituency, [Array<Grom::Node] constituencies redirects to /constituencies/[letters]
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
