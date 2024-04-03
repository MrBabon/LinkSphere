class Api::V1::EventsController < ApplicationController
    after_action :verify_policy_scoped, only: :index

    def index
        @events = Event.all
 
        @events = policy_scope(Event).where('end_time > ?', Time.zone.today - 1.day).order(start_time: :asc)
        @events = @events.search_by_city(params[:city]) if params[:city].present?
        @events = @events.search_by_country(params[:country]) if params[:country].present?
        @events = @events.search_by_title(params[:title]) if params[:title].present?
        @events = @events.search_by_region(params[:region]) if params[:region].present?
        @events_by_month = @events.group_by { |event| event.start_time.beginning_of_month }
        @participations = {}
        @events.each do |event|
          @participations[event.id] = Participation.participation_for(current_user, event)
        end
    end

    def show
        @event = Event.find(params[:id])
        @participation = Participation.new(event: @event) # Initialisation pour le formulaire

        @existing_participation = Participation.participation_for(current_user, @event)
        authorize @event
        @visible_participations = @event.participations.where(visible_in_participants: false)
    end
      

    def exposant
        @event = Event.find(params[:id])
        @exhibitors = @event.exhibitors
        @participation = Participation.participation_for(current_user, @event)
    end

    def visitor
        @event = Event.find(params[:id])
        authorize @event, :visitor?
        @visible_participations = @event.participations.where(visible_in_participants: true)
        if current_user
            user_participation = Participation.find_by(event_id: @event.id, user_id: current_user.id)
            if user_participation && !user_participation.visible_in_participants
                # Exclure la participation de l'utilisateur s'il a choisi de ne pas être visible
                redirect_to api_v1_event_path(@event), alert: "You do not have access to this page. Please validate your visibility to access it."
                return
            end
            @visible_participations = @visible_participations.where.not(id: user_participation.id)
        else
            # Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
            redirect_to new_user_session_path, notice: "You must be logged in to access this page."
        end    
        respond_to do |format|
            format.html # Vue HTML pour les utilisateurs autorisés
            format.json { render json: @visible_participations } # ou un format adapté selon votre API
        end
    end

    def exposant
        @event = Event.find(params[:id])
        authorize @event
        @exhibitors = @event.exhibitors
        @participation = Participation.participation_for(current_user, @event)
        @visible_participations = @event.participations.where(visible_in_participants: false)
    end

    private

    def user_params
        params.require(:user).permit(:title, :logo, :address, :description, :link, :start_time, :end_time, :registration_code)
    end

    def map_view(event)
        {
        lat: event.latitude,
        lng: event.longitude,
        city: event.city,
        country: event.country,
        region: event.region,
        info_window_html: render_to_string(partial: "info_window", locals: {event: event})
        }
    end
end
