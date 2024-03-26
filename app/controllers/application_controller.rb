class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_user_signed_in

  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization
  
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :avatar, :job, :biography, :industry, :website, :linkedin, :instagram, :facebook, :twitter, :entreprise_code])
  end


  protected

  def after_sign_in_path_for(resource)
    profil_api_v1_user_path(resource) # Redirige vers la page de profil du user après la connexion
  end

  def after_sign_out_path_for(resource_or_scope)
    # Redirige vers la page d'accueil après déconnexion
    api_v1_root_path
  end

  def after_sign_up_path_for(resource)
    profil_api_v1_user_path(resource) # Redirige vers la page de profil du user après l'inscription
  end

  def after_inactive_sign_up_path_for(resource)
    profil_api_v1_user_path(resource)
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)|(^api\/v1\/pages$)/
  end

  def check_user_signed_in
    if user_signed_in? && request.original_fullpath == root_path
      redirect_to profil_api_v1_user_path(current_user)
    end
  end


end
