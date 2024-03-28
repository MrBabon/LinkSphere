class Api::V1::ContactGroupsController < ApplicationController
  before_action :set_contact_group, only: [:destroy, :update]

  def show
    begin
      repertoire = current_user.repertoire
      @contact_group = repertoire.contact_groups.find(params[:id])
      @users = @contact_group.users.joins(:user_contact_groups).select('users.*, user_contact_groups.created_at AS created_at').order('created_at DESC, last_name')
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @users = @contact_group.users.where("first_name ILIKE ? OR last_name ILIKE ?", search_term, search_term)
      else
        @users = @contact_group.users.order(:last_name)
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { render :show, status: :not_found }
        format.json { render json: { error: "Access denied or Contact Group not found." }, status: :not_found }
      end
    else
      authorize @contact_group, :show?
      respond_to do |format|
        format.html # cherche automatiquement la vue correspondante, par ex. app/views/api/v1/contact_groups/show.html.erb
        format.json { render json: @contact_group.as_json(include: { users: { only: [:id, :first_name, :last_name] } }) }
      end
    end
  end
  
  def create
    @repertoire = current_user.repertoire
    @contact_group = @repertoire.contact_groups.build(contact_group_params)
    respond_to do |format|
      if @contact_group.save
        format.html { redirect_to repertoire_api_v1_user_path(current_user), notice: 'Contact group was successfully created.' }
        format.json { render json: @contact_group, status: :created }
      else
        format.html { redirect_to repertoire_api_v1_user_path(current_user), alert: 'There was a problem creating the contact group.' }
        format.json { render json: @contact_group.errors, status: :unprocessable_entity }
      end
    end
    authorize @contact_group, :create?
  end

  def update
    respond_to do |format|
      if @contact_group.update(contact_group_params)
        format.html { redirect_to api_v1_contact_group_path(@contact_group), notice: "#{@contact_group.name} updated successfully." }
        format.json { render json: @contact_group }
      else
        format.html { redirect_to api_v1_contact_group_path(@contact_group), alert: 'There was a problem updating the name.' }
        format.json { render json: @contact_group.errors, status: :unprocessable_entity }
      end
    end
    authorize @contact_group, :update?
  end

  def destroy
    respond_to do |format|
      if @contact_group.destroy
        format.html { redirect_to repertoire_api_v1_user_path(current_user), notice: 'The group has been successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to repertoire_api_v1_user_path(current_user), alert: 'There was a problem deleting the group.' }
        format.json { render json: @contact_group.errors, status: :unprocessable_entity }
      end
    end
    authorize @contact_group, :destroy?
  end


  private

  def set_contact_group
    @contact_group = ContactGroup.find(params[:id])
  end

  def contact_group_params
    params.require(:contact_group).permit(:name, :deletable)
  end
end
