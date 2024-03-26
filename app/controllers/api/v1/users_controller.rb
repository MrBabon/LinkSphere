class Api::V1::UsersController < ApplicationController

    def profil
        @user = current_user
        respond_to do |format|
            format.html # cherche automatiquement la vue correspondante, par ex. app/views/users/profil.html.erb
            format.json { render json: @user }
        end
        authorize @user
    end

    def settings
        @user = current_user
        respond_to do |format|
            format.html
            format.json { render json: @user }
        end
        authorize @user
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :avatar, :job, :biography, :industry, :website, :linkedin, :instagram, :facebook, :twitter)
    end
end
