class ConstituenciesController < ApplicationController
  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.

  def index
    @constituencies, @letters = RequestHelper.filter_response_data(
      parliament_request.constituencies,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Redirects to a single constituency given an external source and an id that identifies this constituency in that source.
  # @controller_action_param :source [String] external source.
  # @controller_action_param :id [String] external id which identifies a constituency.

  def lookup
    source = params[:source]
    id = params[:id]

    @constituency = parliament_request.constituencies.lookup(source, id).get.first

    redirect_to constituency_path(@constituency.graph_id)
  end

  # Renders a single constituency given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup'.

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

  # Post method which accepts form parameters from postcode lookup and redirects to constituency_path.
  # @controller_action_param :postcode [String] postcode entered into postcode lookup form.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.

  def postcode_lookup
    flash[:postcode] = params[:postcode]

    redirect_to constituency_path(params[:constituency_id])
  end


  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.

  def current
    @constituencies, @letters = RequestHelper.filter_response_data(
      parliament_request.constituencies.current,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a constituency that has a constituency area object on map view given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup' which holds a geo polygon.

  def map
    constituency_id = params[:constituency_id]

    @constituency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id),
      'http://id.ukpds.org/schema/ConstituencyGroup'
    ).first
  end

  # Renders a contact point given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup' which has a contact point.

  def contact_point
    constituency_id = params[:constituency_id]

    @constituency = RequestHelper.filter_response_data(
      parliament_request.constituencies(constituency_id).contact_point,
      'http://id.ukpds.org/schema/ConstituencyGroup'
    ).first
  end

  # Renders a list of seat incumbents in reverse chronological start date order, given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return Array] Grom::Nodes of type 'http://id.ukpds.org/schema/SeatIncumbency'.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup'.

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

  # Renders a constituency and the current incumbent given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/SeatIncumbency'.

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

  # Renders a list of constituencies that begin with a particular letter given the letter. Shown with an a - z partial view.
  # @controller_action_param :letter [String] single letter that is case insensitive.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.

  def letters
    letter = params[:letter]

    @constituencies, @letters = RequestHelper.filter_response_data(
      parliament_request.constituencies(letter),
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a list of current constituencies that begin with a particular letter given the letter. Shown with an a - z partial view.
  # @controller_action_param :letter [String] single letter that is case insensitive.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.

  def current_letters
    letter = params[:letter]

    @constituencies, @letters = RequestHelper.filter_response_data(
      parliament_request.constituencies.current(letter),
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a list of letters taken from first letter of all constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all constituencies.

  def a_to_z
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.a_z_letters)
  end

  # Renders a list of letters taken from first letter of all current constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all current constituencies.

  def a_to_z_current
    @letters = RequestHelper.process_available_letters(parliament_request.constituencies.current.a_z_letters)
  end

  # Look up to find a constituency given a string.  Redirects to either a single constituency or list of constituencies.
  # @controller_action_param :letters [String] case insensitive string to lookup.

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
