class Api::V1::ContactEntreprisesController < ApplicationController
    def create
        @contact_entreprise = ContactEntreprise.new(contact_entreprise_params)
        @contact_entreprise.user = current_user
        @contact_entreprise.entreprise = Entreprise.find(params[:entreprise_id])
        if @contact_entreprise.save
          # Traitement en cas de succès (redirection, message flash, etc.)
          redirect_to entreprise_path(@contact_entreprise.entreprise), notice: 'Your details were successfully sent.'
        else
          redirect_to entreprise_path(@contact_entreprise.entreprise), alert: 'Your contact details have not been sent.'
        end
    end

    private

    def contact_entreprise_params
        params.require(:contact_entreprise).permit(:user_id, :entreprise_id, :event_id, :category, :message)
    end
end
