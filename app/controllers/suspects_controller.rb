class SuspectsController < ApplicationController
    authorize_resource
    before_action :check_login
  
    def new
      @suspect = Suspect.new
      unless params[:investigation_id].nil?
        @investigation = Investigation.find(params[:investigation_id])
        @investigations_criminals = @investigation.suspects.map{|s| s.criminal}
      end

    end
    
    def create
      @suspect = Suspect.new(suspect_params)
      @suspect.added_on = Date.current.to_date
      if @suspect.save
        flash[:notice] = "Successfully added #{@suspect.criminal.proper_name} on the investigation #{@suspect.investigation.title}."
        # redirect can be show_investigation or criminal_investigation
        redirect_to investigation_path(@suspect.investigation)
      else
        # error message 
        flash[:notice] = "Failed to add #{@suspect.criminal.proper_name} on the investigation #{@suspect.investigation.title}."
        render action: 'new', locals: { investigation_id: @suspect.investigation.id }
      end      
    end

    # only set dropped_on to current date
    def remove
      @suspect = Suspect.find(params[:id])
      @suspect.dropped_on = Date.current.to_date
      @suspect.save
      # redirect can be show_investigation or criminal_investigation
      redirect_to investigation_path(@suspect.investigation)
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def suspect_params
      params.require(:suspect).permit(:criminal_id, :investigation_id, :added_on, :dropped_on)
    end
  
  
  end
  