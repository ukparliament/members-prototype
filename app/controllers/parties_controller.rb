class PartiesController < ApplicationController
  before_action :data_check

  def index
    @parties, @letters = RequestHelper.filter_response_data(
      parliament_request.parties,
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  def show
    party_id = params[:party_id]

    @party = parliament_request.parties(party_id).get.first
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @party = parliament_request.parties.lookup(source, id).get.first

    redirect_to party_path(@party.graph_id)
  end

  def current
    @parties = RequestHelper.filter_response_data(
      parliament_request.parties.current,
      'http://id.ukpds.org/schema/Party'
    ).sort_by(:name)
  end

  def letters
    letter = params[:letter]

    @parties, @letters = RequestHelper.filter_response_data(
      parliament_request.parties(letter),
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  def a_to_z
    @letters = RequestHelper.process_available_letters(parliament_request.parties.a_z_letters)
  end

  def lookup_by_letters
    letters = params[:letters]

    @parties, @letters = RequestHelper.filter_response_data(
      parliament_request.parties.partial(letters),
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    if @parties.size == 1
      redirect_to party_path(@parties.first.graph_id)
      return
    end

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  private

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.parties },
    show: proc { |params| ParliamentHelper.parliament_request.parties(params[:party_id]) },
    lookup: proc { |params| ParliamentHelper.parliament_request.parties.lookup(params[:source], params[:id]) },
    current: proc { ParliamentHelper.parliament_request.parties.current },
    letters: proc { |params| ParliamentHelper.parliament_request.parties(params[:letter]) },
    a_to_z: proc { ParliamentHelper.parliament_request.parties.a_z_letters },
    lookup_by_letters: proc { |params| ParliamentHelper.parliament_request.parties.partial(params[:letters]) }
  }.freeze

  def data_url
    ROUTE_MAP[params[:action].to_sym]
  end
end
