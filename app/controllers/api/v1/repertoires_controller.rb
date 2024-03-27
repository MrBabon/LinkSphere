class Api::V1::RepertoiresController < ApplicationController
    before_action :authenticate_user!
    before_action :load_and_authorize_repertoire, only: [:show]

    def show
    end


    private

    def load_and_authorize_repertoire
        @repertoire = current_user.repertoire
        authorize @repertoire
      end
end
