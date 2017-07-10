class ConstituenciesController < ApplicationController
  before_action :data_check, :build_request, except: :postcode_lookup

  ROUTE_MAP = {
    index:             proc { ParliamentHelper.parliament_request.constituencies },
    show:              proc { |params| ParliamentHelper.parliament_request.constituencies(params[:constituency_id]) },
    lookup:            proc { |params| ParliamentHelper.parliament_request.constituencies.lookup(params[:source], params[:id]) },
    lookup_by_letters: proc { |params| ParliamentHelper.parliament_request.constituencies.partial(params[:letters]) },
    a_to_z_current:    proc { ParliamentHelper.parliament_request.constituencies.current.a_z_letters },
    current:           proc { ParliamentHelper.parliament_request.constituencies.current },
    map:               proc { |params| ParliamentHelper.parliament_request.constituencies(params[:constituency_id]) },
    letters:           proc { |params| ParliamentHelper.parliament_request.constituencies(params[:letter]) },
    current_letters:   proc { |params| ParliamentHelper.parliament_request.constituencies.current(params[:letter]) },
    a_to_z:            proc { ParliamentHelper.parliament_request.constituencies.a_z_letters }
  }.freeze

  # Renders a list of all constituencies with current incumbents and sorted in ascending order by name from a GET request. Shown with an a - z partial view.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def index
    @constituencies, @letters = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a single constituency given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def show
    @postcode = flash[:postcode]

    @constituency, @seat_incumbencies, @party, @person = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      'http://id.ukpds.org/schema/SeatIncumbency',
      'http://id.ukpds.org/schema/Party',
      'http://id.ukpds.org/schema/Person'
    )
    # Instance variable for single MP pages
    @single_mp = true
    @constituency = @constituency.first
    @seat_incumbencies = @seat_incumbencies.reverse_sort_by(:start_date)

    @current_incumbency = @seat_incumbencies.shift if !@seat_incumbencies.empty? && @seat_incumbencies.first.current?

    @json_location = constituency_map_path(@constituency.graph_id, format: 'json')

    @party = @party.first

    @person = @person.first

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

  # Redirects to a single constituency given an external source and an id that identifies this constituency in that source.
  # @controller_action_param :source [String] external source.
  # @controller_action_param :id [String] external id which identifies a constituency.
  def lookup
    @constituency = @request.get.first

    redirect_to constituency_path(@constituency.graph_id)
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
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a constituency that has a constituency area object on map view given a constituency id.
  # Will respond with GeoJSON data using the geosparql-to-geojson gem if JSON is requested.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup' which holds a geo polygon.
  # @return [GeosparqlToGeojson::GeoJson] object containing GeoJSON data if JSON is requested.
  def map
    respond_to do |format|
      format.html do
        @constituency = RequestHelper.filter_response_data(
          @request,
          'http://id.ukpds.org/schema/ConstituencyGroup'
        ).first

        @json_location = constituency_map_path(@constituency.graph_id, format: 'json')
      end

      format.json do
        @constituency = RequestHelper.filter_response_data(
          ParliamentHelper.parliament_request.constituencies(params[:constituency_id]).map,
          'http://id.ukpds.org/schema/ConstituencyGroup'
        ).first

        raise ActionController::RoutingError, 'Not Found' unless @constituency.current?

        render json: GeosparqlToGeojson.convert_to_geojson(
          geosparql_values: @constituency.area.polygon,
          geosparql_properties: {
            name:       @constituency.name,
            start_date: @constituency.start_date,
            end_date:   @constituency.end_date
          },
          reverse: false
        ).geojson
      end
    end
  end

  # Renders a list of seat incumbents in reverse chronological start date order, given a constituency id.
  # @controller_action_param :constituency_id [String] 8 character identifier that identifies constituency in graph database.
  # @return Array] Grom::Nodes of type 'http://id.ukpds.org/schema/SeatIncumbency'.
  # @return [Grom::Node] object with type 'http://id.ukpds.org/schema/ConstituencyGroup'.

  # Renders a list of constituencies that begin with a particular letter given the letter. Shown with an a - z partial view.
  # @controller_action_param :letter [String] single letter that is case insensitive.
  # @return [Array] Grom::Nodes of type 'http://id.ukpds.org/schema/ConstituencyGroup'.
  def letters
    @constituencies, @letters = RequestHelper.filter_response_data(
      @request,
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
    @constituencies, @letters = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  # Renders a list of letters taken from first letter of all constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all constituencies.
  def a_to_z
    @letters = RequestHelper.process_available_letters(@request)
  end

  # Renders a list of letters taken from first letter of all current constituencies. Shown with an a - z partial view.
  # @return [Array] letters representing all current constituencies.
  def a_to_z_current
    @letters = RequestHelper.process_available_letters(@request)
  end

  # Look up to find a constituency given a string.  Redirects to either a single constituency or list of constituencies.
  # @controller_action_param :letters [String] case insensitive string to lookup.
  def lookup_by_letters
    @constituencies, @letters = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ConstituencyGroup',
      ::Grom::Node::BLANK
    )

    if @constituencies.size == 1
      redirect_to constituency_path(@constituencies.first.graph_id)
      return
    end

    @constituencies = @constituencies.sort_by(:name)
    @letters = @letters.map(&:value)
  end
end
