Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  
  # API ROUTES
  namespace :api do
    namespace :v1 do

      root to: "pages#home"

      resources :users do
        member do
          get 'profil'
        end
      end

    end
  end
  
end
