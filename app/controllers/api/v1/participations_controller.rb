class Api::V1::ParticipationsController < ApplicationController
    before_action :set_event, only: [:create, :destroy]
    before_action :set_participation, only: [:destroy]

    def create
        skip_authorization
        @participation = @event.participations.new(participation_params)

        @participation.user = current_user
        unless @event.valid_registration_code?(params[:participation]['registration_code'])
            flash[:alert] = "Incorrect entry code."
            redirect_to api_v1_event_path(@event) and return
        end
        authorize @participation
      
        if @participation.save
            redirect_to api_v1_event_path(@event), notice: "Successful registration."
        else
            flash[:alert] = "Error saving participation."
        end
    end

    def update
        @event = Event.find(params[:event_id])
        @participation = Participation.find_by(user_id: current_user.id, event_id: @event.id)
        @event = @participation.event
        @participation.visible_in_participants = !@participation.visible_in_participants

        if @participation.update(participation_params)
            if @participation.previous_changes.present?
                flash[:notice] = "La participation a été mise à jour avec succès."
            end
            redirect_to api_v1_event_path(@participation.event), notice: 'Your participation visibility has been updated.'
        else
            redirect_to @event, alert: 'Error updating participation.' # Utilisation d'une redirection en cas d'échec
        end
        authorize @participation
    end

    def destroy
        @participation.destroy
        authorize @participation
        if @participation.destroy
            flash[:notice] = "Your registration has been successfully deleted."
            redirect_to api_v1_event_path(@event)
        else
            flash[:alert] = "A problem occurred while trying to delete the registration."
            redirect_to(request.referrer || api_v1_root_path)
        end
    end

    private

    def participation_params
        params.require(:participation).permit(:event_id, :visible_in_participants)
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
