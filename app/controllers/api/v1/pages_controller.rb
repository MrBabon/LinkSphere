class Api::V1::PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [ :home ]

    def home
        @info = { message: "Bienvenue sur l'API version 1" }
        redirect_to profil_api_v1_user_path(current_user) and return if user_signed_in?
        respond_to do |format|
            format.json { render json: @info }
            format.html { render :home }  # Assurez-vous d'avoir une vue correspondante app/views/api/v1/pages/home.html.erb
        end
    end
end
