class Api::V1::MessagesController < ApplicationController

    def create
        @chatroom = Chatroom.find(params[:chatroom_id])
        unless @chatroom.participant?(current_user)
            return render json: { error: 'Unauthorized' }, status: :unauthorized
        end

        @message = Message.new(message_params)
        @message.chatroom = @chatroom
        @message.user = current_user
        authorize @message
        if @message.save
            ChatroomChannel.broadcast_to(
                @chatroom,
                message: render_to_string(partial: "message", locals: {message: @message}),
                sender_id: @message.user.id,
                message_date: @message.created_at.to_date == Date.today ? "Today" : I18n.l(@message.created_at.to_date, format: :long)
            )
            head :ok
        else
          render "chatrooms/show", status: :unprocessable_entity
        end

    end

    private

    def message_params
    params.require(:message).permit(:content)
    end
end
