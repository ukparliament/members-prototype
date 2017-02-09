Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  get '/people/members', to: 'people#members'
  get '/people/members/current', to: 'people#current_members'
  get '/people/a-z', to: 'application#a_to_z', as: 'people_a_z'
  match '/people/a-z/:letter', to: 'people#letters', letter: /[A-Za-z]/, via: [:get], as: 'people_a_z_letter'
  get '/people/members/a-z', to: 'application#a_to_z', as: 'people_members_a_z'
  match '/people/members/a-z/:letter', to: 'people#members_letters', letter: /[A-Za-z]/, via: [:get], as: 'people_members_a_z_letter'
  get '/people/members/current/a-z', to: 'application#a_to_z', as: 'people_members_current_a_z'
  match '/people/members/current/a-z/:letter', to: 'people#current_members_letters', letter: /[A-Za-z]/, via: [:get], as: 'people_members_current_a_z_letter'

  get '/parties/current', to: 'parties#current'
  get '/parties/a-z', to: 'application#a_to_z', as: 'parties_a_z'
  match '/parties/a-z/:letter', to: 'parties#letters', letter: /[A-Za-z]/, via: [:get], as: 'parties_a_z_letter'

  get '/constituencies/current', to: 'constituencies#current'
  get '/constituencies/a-z', to: 'application#a_to_z', as: 'constituencies_a_z'
  match '/constituencies/a-z/:letter', to: 'constituencies#letters', letter: /[A-Za-z]/, via: [:get], as: 'constituences_a_z_letter'
  get '/constituencies/current/a-z', to: 'application#a_to_z', as: 'constituencies_current_a_z'
  match '/constituencies/current/a-z/:letter', to: 'constituencies#current_letters', letter: /[A-Za-z]/, via: [:get], as: 'constituences_current_a_z_letter'

  resources :people, only: [:index, :show] do
    get '/contact_points', to: 'people#contact_points'
    get '/parties', to: 'people#parties'
    get '/parties/current', to: 'people#current_party'
    get '/constituencies', to: 'people#constituencies'
    get '/constituencies/current', to: 'people#current_constituency'
    get '/houses', to: 'people#houses'
    get '/houses/current', to: 'people#current_house'
  end

  resources :parties, only: [:index, :show] do
    get '/members', to: 'parties#members'
    get '/members/current', to: 'parties#current_members'
    get '/members/a-z', to: 'application#a_to_z', as: 'members_a_z'
    match '/members/a-z/:letter', to: 'parties#members_letters', letter: /[A-Za-z]/, via: [:get], as: 'members_a_z_letter'
    get '/members/current/a-z', to: 'application#a_to_z', as: 'members_current_a_z'
    match '/members/current/a-z/:letter', to: 'parties#current_members_letters', letter: /[A-Za-z]/, via: [:get], as: 'members_current_a_z_letter'
  end

  resources :contact_points, only: [:index, :show]

  resources :constituencies, only: [:index, :show] do
    get '/map', to: 'constituencies#map'
    get '/members', to: 'constituencies#members'
    get '/members/current', to: 'constituencies#current_member'
    get '/contact_point', to: 'constituencies#contact_point'
  end

  resources :houses, only: [:index, :show] do
    get '/members', to: 'houses#members'
    get '/members/current', to: 'houses#current_members'
    get '/parties', to: 'houses#parties'
    get '/parties/current', to: 'houses#current_parties'
    get '/parties/:party_id', to: 'houses#party'
    get '/members/a-z', to: 'application#a_to_z', as: 'members_a_z'
    match '/members/a-z/:letter', to: 'houses#members_letters', letter: /[A-Za-z]/, via: [:get], as: 'members_a_z_letter'
    get '/members/current/a-z', to: 'application#a_to_z', as: 'members_current_a_z'
    match '/members/current/a-z/:letter', to: 'houses#current_members_letters', letter: /[A-Za-z]/, via: [:get], as: 'members_current_a_z_letter'
    get '/parties/:party_id/members', to: 'houses#party_members'
    match '/parties/:party_id/members/:letter', to: 'houses#party_members_letters', letter: /[A-Za-z]/, via: [:get], as: 'party_members_letter'
    get '/parties/:party_id/members/current', to: 'houses#current_party_members'
    match '/parties/:party_id/members/current/:letter', to: 'houses#current_party_members_letters', letter: /[A-Za-z]/, via: [:get], as: 'party_members_current_a_z_letter'
  end


  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
