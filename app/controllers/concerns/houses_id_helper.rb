module HouseIdHelper
  def houses_id
    data = Parliament::Request.new.houses.get
    @houses = data.filter('http://id.ukpds.org/schema/House')
    @houses.each do |house|
      case house.houseName
      when 'House of Commons' then @commons_id = house.graph_id
      when 'House of Lords' then @lords_id = house.graph_id
      else
        raise ActionController::RoutingError, 'No Content'
      end
    end
  end
end
