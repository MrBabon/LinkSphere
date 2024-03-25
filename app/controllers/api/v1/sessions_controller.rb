class Api::V1::SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token
      respond_to :json

      def create
        super do |user|
          return render json: { user: user }, status: :ok
        end
      end

      def destroy
        super do
          return head(:ok)
        end
      end

      def new
      render json: { error: "The new action is not supported." }, status: :bad_request
        end

      protected

      def respond_to_on_destroy
        head :no_content
      end
end
