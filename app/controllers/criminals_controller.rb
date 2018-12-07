class CriminalsController < ApplicationController
    before_action :set_criminal, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    def index
      @criminals = Criminal.alphabetical.paginate(page: params[:page]).per_page(10)
      @enhanced_criminals = Criminal.enhanced.alphabetical.paginate(page: params[:page]).per_page(10)
    end
  
    def show
      @current_suspects = @criminal.suspects.current.chronological.to_a.reverse
      @past_suspects = @criminal.suspects.where.not(dropped_on: nil).chronological.to_a.reverse
    end
  
    def new
      @criminal = Criminal.new
    end
  
    def edit
    end
  
    def create
      @criminal = Criminal.new(officer_params)
      if @criminal.save
        flash[:notice] = "Successfully created #{@criminal.proper_name}."
        redirect_to criminal_path(@criminal) 
      else
        render action: 'new'
      end      
    end
  
    def update
      respond_to do |format|
        if @criminal.update_attributes(officer_params)
          format.html { redirect_to @criminal, notice: "Updated all information" }
          
        else
          format.html { render :action => "edit" }
          
        end
      end
    end
  
    def destroy
      if @criminal.destroy
        flash[:notice] = "Successfully destroyed #{@criminal.proper_name}."
        redirect_to officers_path
      else
        render action: 'show'
      end
    end

    def search
      redirect_back(fallback_location: criminals_path) if params[:query].blank?
      @query = params[:query]
      @criminals = Criminal.search(@query)
      @total_hits = @criminals.size
    end
  
  
  
  
  
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_criminal
      @criminal = Criminal.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def criminal_params
      params.require(:criminal).permit(:first_name, :last_name, :aka, :enhanced_powers, :convicted_felon)
    end
  
  
  end
  