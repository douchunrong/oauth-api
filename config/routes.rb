app_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{app_root}/../app/controllers/**/*_controller.rb", &method(:require))

RESOURCE_ROUTES = %i(index create show update destroy).freeze
READ_ONLY_RESOURCE_ROUTES = %i(index show).freeze

Rails.application.routes.draw do
  use_doorkeeper

  namespace :controllers, path: '/' do # , constraints: { subdomain: 'api' } if production?
    namespace :v1, path: 'v1' do
      resources :checkins, only: RESOURCE_ROUTES
      resources :division, only: RESOURCE_ROUTES
      resources :groups, only: RESOURCE_ROUTES
      resources :invites, only: RESOURCE_ROUTES
      resources :organizations, only: RESOURCE_ROUTES
      resources :organizer_types, only: READ_ONLY_RESOURCE_ROUTES
      resources :profile_organizer_types, only: READ_ONLY_RESOURCE_ROUTES
      resources :places, only: RESOURCE_ROUTES
      resources :profiles, only: RESOURCE_ROUTES # @tood: no update
      resources :sports, only: RESOURCE_ROUTES
      resources :users, only: [:new, :create, :show]
    end
  end

  resources :sessions, only: [:new, :create]
  get '/logout', to: 'sessions#destroy', as: :logout
  delete '/logout', to: 'sessions#destroy'

  get '/oauth/me', to: 'controllers/v1/credentials#me'

  root to: 'pages#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
    # resources :checkins

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
