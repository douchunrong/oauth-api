app_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{app_root}/../app/controllers/**/*_controller.rb", &method(:require))

Rails.application.routes.draw do
  use_doorkeeper
  def api_version(version, &routes)
    api_constraint = ApiConstraint.new(version: version)
    scope(module: "v#{version}", constraints: api_constraint, &routes)

    # cutely define the "no version" resource as the last one defined
    # (assuming the last defined is the greatest version #)
    scope(module: "v#{version}", &routes)
  end

  api_version(1) do
    resources :checkins

    resources :users, only: [:new, :create]

    resources :sessions, only: [:new, :create]
    # delete '/logout', to: 'sessions#destroy', as: :session_logout
  end

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
