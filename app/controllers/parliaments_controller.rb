class ParliamentsController < ApplicationController
  before_action :data_check

  def index
    @parliaments = ROUTE_MAP[:index].call.get.reverse_sort_by(:number)
  end

  def current
    @parliament = ROUTE_MAP[:current].call.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def next
    @parliament = ROUTE_MAP[:next].call.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous
    @parliament = ROUTE_MAP[:previous].call.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def lookup
    @parliament = ROUTE_MAP[:lookup].call(params).get.first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def show
    @parliament, @parties = RequestHelper.filter_response_data(
      ROUTE_MAP[:show].call(params),
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/Party'
    )

    @parliament = @parliament.first
    @parties    = @parties.sort_by(:name)
  end

  def next_parliament
    @parliament = ROUTE_MAP[:next_parliament].call(params).get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous_parliament
    @parliament = ROUTE_MAP[:previous_parliament].call(params).get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  private

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.parliaments },
    show: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]) },
    current: proc { ParliamentHelper.parliament_request.parliaments.current },
    next: proc { ParliamentHelper.parliament_request.parliaments.next },
    previous: proc { ParliamentHelper.parliament_request.parliaments.previous },
    next_parliament: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).next },
    previous_parliament: proc { |params| ParliamentHelper.parliament_request.parliaments(params[:parliament_id]).previous }
  }.freeze

  def data_url
    ROUTE_MAP[params[:action].to_sym]
  end
end
