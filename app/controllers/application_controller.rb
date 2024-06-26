class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit::Authorization
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :avatar, :job, :biography, :industry, :website, :linkedin, :instagram, :facebook, :twitter])
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

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || api_v1_root_path) and return
  end



end
