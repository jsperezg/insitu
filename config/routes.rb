# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'invoices#index'

  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: %i[index edit update] do
    member do
      delete :ban
      get :renew
      get :renew_sent
    end

    resources :dashboard, only: [:index]
    resources :payment_methods
    resources :services do
      collection do
        get :csv_template
        post :csv_import
      end
    end

    resources :vats
    resources :units
    resources :customers do
      collection do
        get :csv_template
        post :csv_import
      end
    end

    resources :invoices do
      member do
        get :print
        get :forward_email
        delete :cancel
      end
      collection do
        post :csv_export
      end
    end

    resources :delivery_notes do
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
      resources :estimate_statuses, only: %i[index show]
      resources :invoice_statuses, only: %i[index show]
      resources :project_statuses, only: %i[index show]
      resources :plans, only: [:index]
      resources :dashboard, only: [:index]
      resources :customers, only: %i[index show create update destroy]
      resources :payment_methods, only: %i[index show create update destroy]
      resources :services, only: %i[index show create update destroy]
      resources :units, only: %i[index show create update destroy]
      resources :vats, only: %i[index show create update destroy]
      resources :projects, only: %i[index show create update destroy] do
        resources :tasks, only: %i[index show create update destroy] do
          collection do
            get :invoice_finished
          end
        end
      end

      resources :estimates, only: %i[index show create update destroy] do
        member do
          get :print
          get :invoice
        end
      end

      resources :delivery_notes, only: %i[index show create update destroy] do
        member do
          get :print
          get :invoice
        end
      end

      resources :invoices, only: %i[index show create update destroy] do
        member do
          get :print
          delete :cancel
        end
      end

      devise_scope :user do
        post 'sessions' => 'sessions#create', as: 'login'
        delete 'sessions' => 'sessions#destroy', as: 'logout'
        post 'registrations' => 'registrations#create', as: 'register'
      end
    end
  end

  resources :ipn_listener, only: [:create]
end
