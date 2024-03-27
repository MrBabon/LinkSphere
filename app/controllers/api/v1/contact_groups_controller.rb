class Api::V1::ContactGroupsController < ApplicationController
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
          render json: { error: "Access denied or Contact Group not found." }, status: :not_found
        end
        authorize @contact_group, :show?

      end
    
      def create
        @repertoire = current_user.repertoire
        @contact_group = @repertoire.contact_groups.build(contact_group_params)
        if @contact_group.save
          # Si le groupe de contact est bien enregistré, redirige vers où tu veux, par exemple:
          redirect_to repertoire_api_v1_user_path(current_user), notice: 'Contact group was successfully created.'
        else
          # Si le groupe n'est pas enregistré, il faudra gérer l'erreur. Par exemple, réafficher le formulaire:
          redirect_to repertoire_api_v1_user_path(current_user), alert: "The name was not updated because the length exceeded the allowed limit."
        end
        authorize @contact_group, :create?
      end
    
      def update
        @contact_group = ContactGroup.find(params[:id])
        if @contact_group.update(contact_group_params)
          redirect_to api_v1_contact_group_path(@contact_group), notice: 'Name updated successfully.'
        else
          redirect_to api_v1_contact_group_path(@contact_group), alert: "The name was not updated because the length exceeded the allowed limit."
        end
        authorize @contact_group, :update?
      end
    
      def destroy
        @contact_group = ContactGroup.find(params[:id])
        @contact_group.destroy
        redirect_to repertoire_api_v1_user_path(current_user), notice: 'The group has been successfully deleted.'
        authorize @contact_group, :destroy?
      end
    
    
      private
    
      def contact_group_params
        params.require(:contact_group).permit(:name, :deletable)
      end
end
