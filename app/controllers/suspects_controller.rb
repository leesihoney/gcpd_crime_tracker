class SuspectsController < ApplicationController
    before_action :check_login
  
    def new
      authorize! :new, @officer
      @suspect = Suspect.new
    end

    # only set dropped_on to current date
    def remove
        authorize! :remove, @suspect
        @suspect = Suspect.find(params[:id])
        @suspect.dropped_on = Date.current.to_date
        @suspect.saves
        # redirect can be show_investigation or criminal_investigation

        redirect_to investigation_path(@suspect.investigation)
    end
  
  
  
  
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_officer
      @officer = Officer.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def officer_params
      params.require(:officer).permit(:first_name, :last_name, :rank, :ssn, :active, :unit_id)
    end
  
  
  end
  