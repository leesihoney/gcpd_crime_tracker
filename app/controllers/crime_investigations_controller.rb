class CrimeInvestigationsController < ApplicationController
    before_action :check_login
    authorize_resource

    def new
        @crime_investigation = CrimeInvestigation.new
        @investigation = Investigation.find(params[:investigation_id])
    end

    def create
        @crime_investigation = CrimeInvestigation.new(crime_investigation_params)
        if @crime_investigation.save
            redirect_to investigation_path(@crime_investigation.investigation)
            flash[:notice] = "Successfully added assignment."
        else
            @investigation = Investigation.find(params[:crime_investigation][:officer_id])
            render action: 'new', locals: { investigation: @investigation}
        end
    end

    def destroy
        @crime_investigation = CrimeInvestigation.find(params[:id])
        @investigation = @crime_investigation.investigation
        if @crime_investigation.destroy
            flash[:notice] = "Crime destroyed from #{@investigation.title}"
            redirect_to investigation_path(@crime_investigation.investigation)
        end
    end
    
    private
    def crime_investigation_params
        params.require(:crime_investigation).permit(:crime_id, :investigation_id)
    end
end
  