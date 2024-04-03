class Api::V1::ExhibitorsController < ApplicationController

    def show
        @exhibitor = Exhibitor.find(params[:id])
        @event = @exhibitor.event
        @entreprise = @exhibitor.entreprise
        @participation = Participation.participation_for(current_user, @event)
        authorize @exhibitor
        @visible_participations = @event.participations.where(visible_in_participants: false)

    end

end
