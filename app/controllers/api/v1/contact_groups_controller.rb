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
          redirect_to(root_path, alert: "Access denied or Contact Group not found.")
        end
      end
    
      def create
        @repertoire = current_user.repertoire
        @contact_group = @repertoire.contact_groups.build(contact_group_params)
        if @contact_group.save
          # Si le groupe de contact est bien enregistré, redirige vers où tu veux, par exemple:
          redirect_to repertoire_user_path(current_user), notice: 'Contact group was successfully created.'
        else
          # Si le groupe n'est pas enregistré, il faudra gérer l'erreur. Par exemple, réafficher le formulaire:
          render 'users/repertoire'
        end
      end
    
      def update
        @contact_group = ContactGroup.find(params[:id])
        if @contact_group.update(contact_group_params)
          redirect_to contact_group_path(@contact_group), notice: 'Nom mis à jour avec succès.'
        else
          redirect_to contact_group_path(@contact_group), alert: "Marche pas"
        end
      end
    
      def destroy
        @contact_group = ContactGroup.find(params[:id])
        @contact_group.destroy
        redirect_to repertoire_user_path(current_user), notice: 'The group has been successfully deleted.'
      end
    
    
      private
    
      def contact_group_params
        params.require(:contact_group).permit(:name, :deletable)
      end
end
