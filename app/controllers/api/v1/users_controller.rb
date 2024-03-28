class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.where.not(id: current_user.id)
  end

  def show
    if @user == current_user
        redirect_to profil_api_v1_user_path
    end
    if @user.entrepreneurs?
        @entreprise = @user.entreprises_as_owner.first
    elsif @user.employee_relationships?
        @employee = @user.entreprises_as_employee.first
    end
    @from_contact_group = session.delete(:from_contact_group)
    blocked = current_user.blocks_given.exists?(blocked_id: @user.id) || @user.blocks_given.exists?(blocked_id: current_user.id)

    if blocked
        redirect_to api_v1_root_path, alert: "You cannot view this profile."
    end
  end

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
      respond_to do |format|
        format.html { render 'api/v1/repertoires/show' }
        format.json do
          render json: {
            repertoire: @repertoire,
            contact_groups: @contact_groups,
            users: @users,
            search_active: @search_active
          }
        end
      end
      authorize @repertoire, :show?
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :avatar, :job, :biography, :industry, :website, :linkedin, :instagram, :facebook, :twitter)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
