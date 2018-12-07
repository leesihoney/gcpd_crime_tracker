class InvestigationNotesController < ApplicationController
    authorize_resource
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
    # Never trust parameters from the scary internet, only allow the white list through.
    def suspect_params
      params.require(:suspect).permit(:criminal_id, :investigation_id, :added_on, :dropped_on)
    end
  
  
  end
  