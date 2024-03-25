class Api::V1::RegistrationsController < ApplicationController
    skip_before_action :verify_authenticity_token
      respond_to :json

    def create
        build_resource(sign_up_params)

        resource.save
        if resource.persisted?
            if resource.active_for_authentication?
            sign_up(resource_name, resource)
            render json: { message: "Signed up successfully." }, status: :created
            else
            expire_data_after_sign_in!
            render json: { message: "Signed up but inactive." }, status: :ok
            end
        else
            clean_up_passwords(resource)
            set_minimum_password_length
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
        prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

        resource_updated = update_resource(resource, account_update_params)
        yield resource if block_given?

        if resource_updated
            if is_flashing_format? && update_needs_confirmation?(resource, prev_unconfirmed_email)
            flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
            set_flash_message :notice, flash_key
            end
            sign_in resource_name, resource, bypass: true
            render json: resource, status: :ok
        else
            clean_up_passwords resource
            set_minimum_password_length
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def sign_up_params
        # Liste des paramètres autorisés pour la création
        params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def account_update_params
        # Liste des paramètres autorisés pour la mise à jour
        params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
    end
end
