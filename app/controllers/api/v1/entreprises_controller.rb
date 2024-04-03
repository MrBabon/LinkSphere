class Api::V1::EntreprisesController < ApplicationController
    before_action :set_entreprise, only: :show
    def new
        @entreprise = Entreprise.new
    end
  
    def show
        @contact_entreprise = ContactEntreprise.new(entreprise: @entreprise)
        @employees = @entreprise.employees
        @entrepreneurs = @entreprise.entrepreneurs
        authorize @entreprise
    end

    private
  
    def set_entreprise
      @entreprise = Entreprise.find(params[:id])
    end

    def verify_ownership
      unless current_user.entreprises_as_owner.include?(@entreprise)
        redirect_to root_path, alert: "You do not have rights to edit this entreprise."
      end
    end
  
    def entreprise_params
      params.require(:entreprise).permit(:name, :logo, :banner, :email, :website, :linkedin, :instagram, :facebook, :twitter, :description)
    end

    def existing_representatives
      @entreprise.representatives.pluck(:employee_id, :entrepreneur_id).flatten.compact.uniq
    end
    
    def representatives_params
      params.require(:representative).permit(:exhibitor_id, :entreprise_id, employee_ids: [], entrepreneur_ids: [])
    end
    
end
