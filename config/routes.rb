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
        resources :users_contact_groups, only: [:update]
        resource :repertoire, only: [] do
          resources :contact_groups, only: [:create, :new, :edit]
        end
        member do
          get 'profil'
          get 'settings'
          get 'repertoire'
        end
      end

      resources :contact_groups, only: [:show, :destroy, :update]

      resources :chatrooms, only: [:show, :index, :create, :destroy] do
        resources :messages, only: :create
      end
      
      resources :blocks, only: [:create, :destroy]
    end
  end
  # FIN API ROUTES
  
end
