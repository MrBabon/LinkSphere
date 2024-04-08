class Api::V1::ChatroomsController < ApplicationController
    helper_method :find_or_create_chatroom

    
    def show
        @chatroom = Chatroom.find_by(id: params[:id])
        authorize @chatroom
        if @chatroom
          @message = Message.new
          @messages = @chatroom.messages.order(created_at: :asc)
          @other_user = @chatroom.other_user(current_user)
        else
          redirect_to api_v1_chatrooms_path, alert: "The conversation has been deleted or does not exist."
        end
    end

    def index
        @chatrooms = policy_scope(Chatroom).where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)
        user_ids = @chatrooms.flat_map { |chatroom| [chatroom.user1_id, chatroom.user2_id] }.uniq - [current_user.id]
      
        if params[:search].present?
            Rails.logger.debug "Search term: #{params[:search]}"

            @users = User.search_by_name(params[:search]).where(id: user_ids)
            Rails.logger.debug "Filtered users: #{@users.map(&:id)}"

        else
            @users = User.where(id: user_ids)
        end  
    end

    def create
        other_user = User.find(params[:other_user_id])
        chatroom = find_or_create_chatroom(current_user, other_user)
        authorize chatroom
        redirect_to api_v1_chatroom_path(chatroom)
    end

    def destroy
        @chatroom = Chatroom.find(params[:id])
        @chatroom.destroy
        ChatroomChannel.broadcast_to(
            @chatroom,
            { action: "chatroom_deleted" }
        )
        redirect_to api_v1_chatrooms_path(current_user), notice: 'The group has been successfully deleted.'
    end

    private
  
    def find_or_create_chatroom(user1, user2)
        chatroom = Chatroom.find_by(user1: user1, user2: user2) || 
                Chatroom.find_by(user1: user2, user2: user1)

        unless chatroom
        chatroom = Chatroom.create(user1: user1, user2: user2)
        end

        chatroom
    end
end
