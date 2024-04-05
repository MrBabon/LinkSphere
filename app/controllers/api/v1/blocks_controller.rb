class Api::V1::BlocksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_block, only: [:destroy]


  def create
    blocked_user = User.find(params[:blocked_id])
    block = current_user.blocks_given.create!(blocked: blocked_user)
    
    authorize block

    # Supprimez également la discussion si nécessaire
    chat = Chatroom.find(params[:chatroom_id])
    chat.destroy
      ChatroomChannel.broadcast_to(
        chat,
        { action: "chatroom_deleted" }
      )

    # Supprimez du repertoire current et user

    # Repertoire de l'user bloqué
    repertoire_other = blocked_user.repertoire
    everyone_group_other = repertoire_other.contact_groups.find_by(name: 'Everyone')
    if everyone_group_other
        association = UserContactGroup.find_by(user: current_user, contact_group: everyone_group_other)
        association.destroy if association
    end
    # Repertoire du current_user
    repertoire = current_user.repertoire
    everyone_group = repertoire.contact_groups.find_by(name: 'Everyone')
    if everyone_group
        association = UserContactGroup.find_by(user: blocked_user, contact_group: everyone_group)
        association.destroy if association
    end
    
    redirect_to api_v1_chatrooms_path(current_user), notice: "User has been blocked and the conversation was deleted."

  end

  def destroy
    if current_user == @block.blocker
        @block.destroy
        redirect_to profil_user_path(current_user), notice: 'User has been successfully unblocked.'
    else
        redirect_to profil_user_path(current_user), alert: 'You do not have permission to unblock this user.'
    end
  end

  private

  def set_block
    @block = Block.find(params[:id])
  end
end
