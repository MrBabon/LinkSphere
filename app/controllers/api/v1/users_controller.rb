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

  def my_events
    @user = current_user
    authorize @user
    @participating_events = @user.events.where('end_time > ?', Time.zone.today - 1.day).order(start_time: :asc)
    @participating_events_by_month = @participating_events.group_by { |event| event.start_time.beginning_of_month }
    @participating_events = @participating_events.search_by_city(params[:city]) if params[:city].present?
    @participating_events = @participating_events.search_by_country(params[:country]) if params[:country].present?
    @participating_events = @participating_events.search_by_title(params[:title]) if params[:title].present?
    @participating_events = @participating_events.search_by_region(params[:region]) if params[:region].present?
    @visible_in_participants = {}

    # Boucle à travers les événements auxquels l'utilisateur participe pour obtenir la visibilité
    @participating_events.each do |event|
        participation = Participation.participation_for(@user, event)
        if participation
          @visible_in_participants[event.id] = participation.visible_in_participants
        else
          @visible_in_participants[event.id] = false  # Par défaut, l'utilisateur n'est pas visible s'il n'est pas inscrit
        end
    end
    @participation = Participation.find_by(user_id: @user.id)  # Assurez-vous que cela correspond à la logique de récupération de votre participation existante
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :avatar, :job, :biography, :industry, :website, :linkedin, :instagram, :facebook, :twitter)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
