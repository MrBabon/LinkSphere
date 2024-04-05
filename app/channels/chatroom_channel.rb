class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find_by(id: params[:id])
    if chatroom
      stream_for chatroom
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
