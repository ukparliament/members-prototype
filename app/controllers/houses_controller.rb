class HousesController < ApplicationController
  def index
    # @houses = order_list(House.eager_all, :id)
    #
    # format({ serialized_data: @houses })
  end

  def show
    # @house = House.eager_find(params[:id]) or not_found
    #
    # format({ serialized_data: @house })
  end

  def members
    # @house = House.eager_find(params[:house_id], 'members') or not_found
    # @members = order_list(@house.members, :surname, :forename)
    #
    # format({ serialized_data: @house })
  end

  def current_members
    # @house = House.eager_find(params[:house_id], 'members', 'current') or not_found
    # @members = order_list(@house.members, :surname, :forename)
    #
    # format({ serialized_data: @house })
  end

  def parties
    # @house = House.eager_find(params[:house_id], 'parties') or not_found
    # @parties = order_list(@house.parties, :name)
    #
    # format({ serialized_data: @house })
  end

  def current_parties
    # @house = House.eager_find(params[:house_id], 'parties', 'current') or not_found
    # @parties = order_list(@house.parties, :name)
    #
    # format({ serialized_data: @house })
  end

  def members_letters
    # letter = params[:letter]
    # @root_path = house_members_a_z_path
    # @house = House.eager_find(params[:house_id], 'members', letter)
    # @members = order_list(@house.members, :surname, :forename)
    #
    # format({ serialized_data: @house })
  end

  def current_members_letters
    # letter = params[:letter]
    # @root_path = house_members_current_a_z_path
    # @house = House.eager_find(params[:house_id], 'members', 'current', letter)
    # @members = order_list(@house.members, :surname, :forename)
    #
    # format({ serialized_data: @house })
  end
end
