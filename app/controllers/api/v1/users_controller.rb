class Api::V1::UsersController < ApplicationController

    def profil
        @user = current_user
        respond_to do |format|
            format.html # cherche automatiquement la vue correspondante, par ex. app/views/users/profil.html.erb
            format.json { render json: @user }
            authorize @user
        end
    end
end
