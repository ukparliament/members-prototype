class ParliamentsController < ApplicationController
  before_action :data_check

  def index
    @parliaments = parliament_request.parliaments.get.reverse_sort_by(:number)
  end

  def current
    @parliament = parliament_request.parliaments.current.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def next
    @parliament = parliament_request.parliaments.next.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous
    @parliament = parliament_request.parliaments.previous.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def lookup
    source = params[:source]
    id = params[:id]

    @parliament = parliament_request.parliaments.lookup(source, id).get.first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def show
    parliament_id = params[:parliament_id]

    @parliament, @parties = RequestHelper.filter_response_data(
      parliament_request.parliaments(parliament_id),
      'http://id.ukpds.org/schema/ParliamentPeriod',
      'http://id.ukpds.org/schema/Party'
    )

    @parliament = @parliament.first
    @parties    = @parties.sort_by(:name)
  end

  def next_parliament
    parliament_id = params[:parliament_id]

    @parliament = parliament_request.parliaments(parliament_id).next.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  def previous_parliament
    parliament_id = params[:parliament_id]

    @parliament = parliament_request.parliaments(parliament_id).previous.get.filter('http://id.ukpds.org/schema/ParliamentPeriod').first

    redirect_to parliament_path(@parliament.graph_id)
  end

  private

  ROUTE_MAP = {
    index: proc { ParliamentHelper.parliament_request.parliaments },
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
