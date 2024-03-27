class Api::V1::UserContactGroupsController < ApplicationController

    def update
        @user_contact_group = UserContactGroup.find(params[:id])
        @user = @user_contact_group.user
        
        if @user_contact_group.update(user_contact_group_params)
            redirect_to repertoire_api_v1_user_profile_user_path(@user), notice: 'Note updated successfully.'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private

    def user_contact_group_params
    params.require(:user_contact_group).permit(:personal_note)
    end
end
