class PartiesController < ApplicationController
  def index
    # @parties = order_list(Party.eager_all, :name)
    #
    # format({ serialized_data: @parties })
  end

  def current
    # @parties = order_list(Party.eager_all('current'), :name)
    #
    # format({ serialized_data: @parties })
  end

  def show
    # @party = Party.eager_find(params[:id]) or not_found
    #
    # format({ serialized_data: @party })
  end

  def members
    # @party = Party.eager_find(params[:party_id], 'members') or not_found
    # @members = order_list(@party.members, :surname, :forename)
    #
    # format({ serialized_data: @party })
  end

  def current_members
    # @party = Party.eager_find(params[:party_id], 'members', 'current') or not_found
    # @members = order_list(@party.members, :surname, :forename)
    #
    # format({ serialized_data: @party })
  end

  def letters
    # letter = params[:letter]
    # @root_path = parties_a_z_path
    # @parties = order_list(Party.eager_all(letter), :name)
    #
    # format({ serialized_data: @parties })
  end

  def members_letters
    # letter = params[:letter]
    # @root_path = party_members_a_z_path
    # @party = Party.eager_find(params[:party_id], 'members', letter)
    # @members = order_list(@party.members, :surname, :forename)
    #
    # format({ serialized_data: @party })
  end

  def current_members_letters
    # letter = params[:letter]
    # @root_path = party_members_current_a_z_path
    # @party = Party.eager_find(params[:party_id], 'members', 'current', letter)
    # @members = order_list(@party.members, :surname, :forename)
    #
    # format({ serialized_data: @party })
  end
end
