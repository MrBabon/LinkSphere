class Api::V1::ChatroomsController < ApplicationController
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
        @chatrooms = current_user.chatrooms.joins(:messages).distinct
        @chatrooms = policy_scope(Chatroom).joins(:messages).distinct
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
