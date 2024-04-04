Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root to: "pages#home"
  
  # API ROUTES
  namespace :api do
    namespace :v1 do

      # Ne fonctionne pas a voir comment faire plus tard!
      devise_for :users, controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }

      root to: "pages#home"

      resources :users do
        resources :user_contact_groups, only: [:update]
        resource :repertoire, only: [] do
          resources :contact_groups, only: [:create, :new, :edit]
        end
        member do
          get 'profil'
          get 'settings'
          get 'repertoire'
          get 'my_events'
          get 'repertoire_user_profil'
          # A SUPRIMER PLUS TARD
          post 'add_to_directory'
          ######################
        end
      end

      resources :contact_groups, only: [:show, :destroy, :update]

      resources :chatrooms, only: [:show, :index, :create, :destroy] do
        resources :messages, only: :create
      end
      
      resources :blocks, only: [:create, :destroy]

      resources :events, only: [:index, :show] do
        member do
          get 'visitor'
          get 'exposant'
        end
        resources :participations, only: [:create, :destroy, :update]
      end
      
      resources :participations, only: [:update]
      
      resources :exhibitors, only: [:show]
      resources :representatives, only: [:destroy]
    
      resources :entreprises, only: [:edit, :update, :show, :new, :create] do
        resources :employees, only: [:destroy]
        resources :contact_entreprises, only: :create
        member do
          post 'add_representatives'
          get 'dashboard'
        end
      end
    end
  end
  # FIN API ROUTES
  
end
