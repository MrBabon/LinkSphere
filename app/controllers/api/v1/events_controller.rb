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
        @participation = Participation.participation_for(current_user, @event)
        @visible_in_participants = {}

        if @participation.present?
            @visible_in_participants[@event.id] = @participation.visible_in_participants
        else
            @visible_in_participants[@event.id] = false
        end
    end

    def exposant
        @event = Event.find(params[:id])
        @exhibitors = @event.exhibitors
        @participation = Participation.participation_for(current_user, @event)
        @visible_in_participants = {}

        if @participation.present?
            @visible_in_participants[@event.id] = @participation.visible_in_participants
        else
            @visible_in_participants[@event.id] = false
        end
    end

    def visitor
        @event = Event.find(params[:id])
        @visible_participations = @event.participations.where(visible_in_participants: true)
        if current_user
            user_participation = Participation.find_by(event_id: @event.id, user_id: current_user.id)
            if user_participation.nil? || !user_participation.visible_in_participants
                # Exclure la participation de l'utilisateur s'il a choisi de ne pas être visible
                redirect_to my_events_user_path(current_user), alert: "Vous n'avez pas accès à cette page. Veuillez valider votre visibilité pour y accéder."
                return
            end
            @visible_participations = @visible_participations.where.not(id: user_participation.id)
        else
            # Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
            redirect_to new_user_session_path, notice: "Vous devez être connecté pour accéder à cette page."
        end    
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
