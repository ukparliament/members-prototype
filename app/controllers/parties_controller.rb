class PartiesController < ApplicationController
  before_action :data_check

  def index
    @parties, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:index].call,
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  def show
    @party = ROUTE_MAP[:show].call(params).get.first
  end

  def lookup
    @party = ROUTE_MAP[:lookup].call(params).get.first

    redirect_to party_path(@party.graph_id)
  end

  def current
    @parties = RequestHelper.filter_response_data(
      ROUTE_MAP[:current].call,
      'http://id.ukpds.org/schema/Party'
    ).sort_by(:name)
  end

  def letters
    @parties, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:letters].call(params),
      'http://id.ukpds.org/schema/Party',
      ::Grom::Node::BLANK
    )

    @parties = @parties.sort_by(:name)
    @letters = @letters.map(&:value)
  end

  def a_to_z
    @letters = RequestHelper.process_available_letters(ROUTE_MAP[:a_to_z].call)
  end

  def lookup_by_letters
    @parties, @letters = RequestHelper.filter_response_data(
      ROUTE_MAP[:lookup_by_letters].call(params),
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
