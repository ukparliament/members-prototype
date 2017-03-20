module HousesHelper
  def self.commons?(house)
    set_ids

    house.graph_id == @commons_id
  end

  def self.lords?(house)
    !commons?(house)
  end

  def self.commons_id
    set_ids

    @commons_id
  end

  def self.lords_id
    set_ids

    @lords_id
  end

  private_class_method

  def self.set_ids
    unless @commons_id && @lords_id
      houses = Parliament::Request.new.houses.get.filter('http://id.ukpds.org/schema/House').sort_by(:name)

      @commons_id = houses.first.graph_id
      @lords_id = houses.last.graph_id
    end
  end
end
