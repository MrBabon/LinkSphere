Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root to: "pages#home"
  
  # API ROUTES
  namespace :api do
    namespace :v1 do

      # NE FONCTIONNE PAS a voir comment faire plus tard!
      devise_for :users, controllers: {
        sessions: 'api/v1/sessions',
        registrations: 'api/v1/registrations'
      }

      root to: "pages#home"

      resources :users do
        member do
          get 'profil'
          get 'settings'
        end
      end

    end
  end
  
end
