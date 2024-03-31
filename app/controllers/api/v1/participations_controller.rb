class Api::V1::ParticipationsController < ApplicationController
    before_action :set_event, only: [:create]
    before_action :set_participation, only: [:destroy]

    def create
        Rails.logger.debug "Received params: #{params.inspect}"

        skip_authorization
        @participation = @event.participations.new(participation_params)
        @participation.user = current_user
        unless @event.valid_registration_code?(params[:participation]['registration_code'])
            flash[:alert] = "Code de participation incorrect."
            redirect_to api_v1_event_path(@event) and return
        end
        authorize @participation
      
        if @participation.save
            redirect_to api_v1_event_path(@event), notice: "Inscription réussie."
        else
            flash[:alert] = "Erreur lors de l'enregistrement de la participation."

        end
    end

    def update
        @participation = Participation.find(params[:id])
        if @participation.update(participation_params)
            if @participation.previous_changes.present?
                flash[notice] = "La participation a été mise à jour avec succès."
            end
            redirect_to visitor_api_v1_event_path(@participation.event)
        else
          flash[:alert] = "Erreur lors de la mise à jour de la participation."
          render :edit
        end
    end

    def destroy
        @event = Event.find(params[:event_id])
        @participation.destroy
        redirect_to api_v1_event_path(@event)
        flash[:notice] = "Votre inscription a été supprimée avec succès."
        authorize @participation
    end

    private

    def participation_params
        params.require(:participation).permit(:event_id, :user_id, :visible_in_participants)
    end
    
    def event_params
        params.require(:event).permit(:event_id)
    end

    def set_participation
        @participation = Participation.find(params[:id])
    end

    def set_event
        @event = Event.find(params[:event_id])
    end
end
