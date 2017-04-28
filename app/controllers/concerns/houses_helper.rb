require 'parliament_helper'

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

  # Returns the current house id for the page alongside the other house id.
  #
  # @param [Grom::Node] house The house that a particular person is linked to.
  # @return [Array<String, String>] The current house id and other house id.
  def self.house_id_string(house)
    is_commons = HousesHelper.commons?(house)

    house_ids = [commons_id, lords_id]
    return house_ids if is_commons

    house_ids.reverse
  end

  # Returns the current
  #
  # @param [Grom::Node] house The house that a particular person is linked to.
  # @return [Array<String, String>] The current person type and other person type.
  def self.person_type_string(house)
    is_mp = HousesHelper.commons?(house)

    types = [I18n.t('mp_plural'), I18n.t('lord_plural')]

    return types if is_mp

    types.reverse
  end

  private_class_method

  def self.set_ids
    return if @commons_id && @lords_id
    houses = ParliamentHelper.parliament_request.houses.get.filter('http://id.ukpds.org/schema/House').sort_by(:name)

    @commons_id = houses.first.graph_id
    @lords_id = houses.last.graph_id
  end
end
