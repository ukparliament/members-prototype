Rails.application.routes.draw do
  def listable(letter_action)
    scope '/a-z', as: 'a_z' do
      get '/',        to: 'application#a_to_z'

      scope '/:letter', as: 'letter' do
        get '/', to: letter_action
      end
    end
  end

  def lookupable(action)
    get '/:letters', to: action
  end

  id_format_regex = /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/


  ### Root ###
  # /
  root 'home#index'


  ### People ###
  # /people (multiple 'people' scope)
  scope '/people', as: 'people' do
    get '/', to: 'people#index'

    listable('people#letters')

    # /people/members
    scope '/members', as: 'members' do
      get '/', to: 'people#members'

      listable('people#members_letters')

      # /people/members/current
      scope '/current', as: 'current' do
        get '/', to: 'people#current_members'

        listable('people#current_members_letters')
      end
    end
  end

  # /people (single 'person' scope)
  scope '/people', as: 'person' do
    # /people/:person_id
    scope '/:person_id' do
      get '/', to: 'people#show', person_id: id_format_regex

      # /people/:person_id/constituencies
      scope '/constituencies', as: 'constituencies' do
        get '/',        to: 'people#constituencies'
        get '/current', to: 'people#current_constituency'
      end

      get '/contact-points', to: 'people#contact_points'

      # /people/:person_id/houses
      scope '/houses', as: 'houses' do
        get '/',        to: 'people#houses'
        get '/current', to: 'people#current_house'
      end

      # /people/:person_id/parties
      scope '/parties', as: 'parties' do
        get '/',        to: 'people#parties'
        get '/current', to: 'people#current_party'
      end
    end

    # Allow lookups - but ensure they are SECOND in the routes list after /people/:person_id
    lookupable('people#lookup_by_letters')
  end

  ### Parties ###
  # /parties (multiple 'parties' scope)
  scope '/parties', as: 'parties' do
    get '/',        to: 'parties#index'
    get '/current', to: 'parties#current'

    listable('parties#letters')
  end

  # /parties (single 'party' scope)
  scope '/parties', as: 'party' do
    # /parties/:party_id
    scope '/:party_id' do
      get '/', to: 'parties#show', party_id: id_format_regex

      # /parties/:party_id/members
      scope '/members', as: 'members' do
        get '/', to: 'parties#members'

        listable('parties#members_letters')

        # /parties/:party_id/members/current
        scope '/current', as: 'current' do
          get '/', to: 'parties#current_members'

          listable('parties#current_members_letters')
        end
      end
    end

    # Allow lookups - but ensure they are SECOND in the routes list after /parties/:party_id
    lookupable('parties#lookup_by_letters')
  end

  ### Constituencies ###
  # /constituencies (multiple 'constituencies' scope)
  scope '/constituencies', as: 'constituencies' do
    get '/', to: 'constituencies#index'

    listable('constituencies#letters')

    # /constituencies/current
    scope '/current', as: 'current' do
      get '/', to: 'constituencies#current'

      listable('constituencies#current_letters')
    end
  end

  # /constituencies (single 'constituency' scope)
  scope '/constituencies', as: 'constituency' do
    # /constituencies/:constituency_id
    scope '/:constituency_id' do
      get '/', to: 'constituencies#show', constituency_id: id_format_regex
      get '/contact_point', to: 'constituencies#contact_point'
      get '/map', to: 'constituencies#map'

      # /constituencies/:constituency_id/members
      scope '/members', as: 'members' do
        get '/', to: 'constituencies#members'
        get '/current', to: 'constituencies#current_member'
      end
    end

    # Allow lookups - but ensure they are SECOND in the routes list after /constituencies/:constituency_id
    lookupable('constituencies#lookup_by_letters')
  end


  ## Contact Points ##
  # /contact-points  (multiple 'contact_points' scope)
  scope '/contact-points', as: 'contact_points' do
    get '/', to: 'contact_points#index'
  end

  # /contact-points (single 'contact_point' scope)
  scope '/contact-points', as: 'contact_point' do
    # /contact-points/:contact_point_id
    scope '/:contact_point_id' do
      get '/', to: 'contact_points#show', contact_point_id: id_format_regex
    end
  end

  ## Houses ##
  # /houses (multiple 'houses' scope)
  scope '/houses', as: 'houses' do
    get '/', to: 'houses#index'
  end

  # /houses (single 'house' scope)
  scope '/houses', as: 'house' do
    # /houses/:house_id
    scope '/:house_id' do
      get '/', to: 'houses#show', house_id: id_format_regex

      # /houses/:house_id/members
      scope '/members', as: 'members' do
        get '/', to: 'houses#members'

        listable('houses#members_letters')

        # /houses/:house_id/members/current
        scope '/current', as: 'current' do
          get '/', to: 'houses#current_members'

          listable('houses#current_members_letters')
        end
      end

      # /houses/:house_id/parties
      scope '/parties', as: 'parties' do
        get '/', to: 'houses#parties'
        get '/current', to: 'houses#current_parties'

        # /houses/:house_id/parties/:party_id
        scope '/:party_id' do
          get '/', to: 'houses#party'

          # /houses/:house_id/parties/:party_id/members
          scope '/members' do
            get '/', to: 'houses#party_members'

            listable('houses#party_members_letters')

            # /houses/:house_id/parties/:party_id/members/current
            scope '/current' do
              get '/', to: 'houses#current_party_members'

              listable('houses#current_party_members_letters')
            end
          end
        end
      end
    end

    # Allow lookups - but ensure they are SECOND in the routes list after /houses/:house_id
    lookupable('houses#lookup_by_letters')
  end


  ## Meta ##
  # /meta
  scope '/meta', as: 'meta' do
    get '/', to: 'meta#index'
    get '/cookie-policy', to: 'meta#cookie_policy'
  end
end
