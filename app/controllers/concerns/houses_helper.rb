# Namespace for helpers of the HousesController.
module HousesHelper
  # Checks if house is the House of Commons and sets @commons_id and @lords_id if not already set.
  #
  # @param [Grom::Node] house a Grom::Node with type http://id.ukpds.org/schema/House.
  # @return [Boolean] boolean depending on whether the house has the same id as the House of Commons.
  def self.commons?(house)
    set_ids

    house.graph_id == @commons_id
  end

  # Checks if house is the House of Lords and sets @commons_id and @lords_id if not already set.
  #
  # @param [Grom::Node] house a Grom::Node with type http://id.ukpds.org/schema/House.
  # @return [Boolean] boolean depending on whether the house has the same id as the House of Lords.
  def self.lords?(house)
    !commons?(house)
  end

  # Sets and returns the id for the House of Commons.
  #
  # @return [String] @commons_id the id for the House of Commons.
  def self.commons_id
    set_ids

    @commons_id
  end

  # Sets and returns the id for the House of Lords.
  #
  # @return [String] @lords_id the id for the House of Lords.
  def self.lords_id
    set_ids

    @lords_id
  end

  private_class_method

  def self.set_ids
    return if @commons_id && @lords_id
    houses = Parliament::Request.new.houses.get.filter('http://id.ukpds.org/schema/House').sort_by(:name)

    @commons_id = houses.first.graph_id
    @lords_id = houses.last.graph_id
  end
end
