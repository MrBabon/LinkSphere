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

    def repertoire
        @repertoire = current_user.repertoire
        @contact_groups = @repertoire.contact_groups
        @contact_group = ContactGroup.new
        @groups = @repertoire.contact_groups.includes(:users)
        if params[:search].present?
          @everyone_group = @groups.find_by(name: "Everyone")
          search = "%#{params[:search]}%"
          @users = @everyone_group.users.where("first_name ILIKE ? OR last_name ILIKE ?", search, search)
          @search_active = true
        else
          @users = []
          @search_active = false
        end
        render 'api/v1/repertoires/show'
        authorize @repertoire, :show?
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :avatar, :job, :biography, :industry, :website, :linkedin, :instagram, :facebook, :twitter)
    end
end
