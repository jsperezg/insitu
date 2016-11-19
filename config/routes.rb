Rails.application.routes.draw do
  root :to => "dashboard#index"

  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :users, only: [ :index, :edit, :update ] do
    member do
      delete :ban
      get :renew
      get :renew_sent
    end

    resources :dashboard
    resources :payment_methods
    resources :services
    resources :vats
    resources :units
    resources :customers

    resources :invoices  do
      member do
        get :print
        get :forward_email
      end
    end

    resources :delivery_notes  do
      member do
        get :print
        get :forward_email
        get :invoice
      end
    end

    resources :estimates do
      member do
        get :print
        get :forward_email
        get :invoice
      end
    end

    resources :projects do
      resources :tasks do
        collection do
          get :invoice_finished
        end
      end
    end
  end

  resources :plans

  namespace :api do
    namespace :v1 do
      resources :plans, only: [:index]
      resources :dashboard, only: [:index]
      resources :customers, only: [:index, :show, :create, :update, :destroy]

      devise_scope :user do
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
        post 'registrations' => 'registrations#create', :as => 'register'
      end
    end
  end

  resources :ipn_listener, only: [:create]


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
