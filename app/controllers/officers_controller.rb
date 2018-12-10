class OfficersController < ApplicationController
  authorize_resource
  before_action :set_officer, only: [:show, :edit, :update, :destroy, :toggle_active_status]
  before_action :check_login

  def index
    @active_officers = Officer.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_officers = Officer.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    @current_assignments = @officer.assignments.current.chronological
    @past_assignments = @officer.assignments.past.chronological
  end

  def new
    @officer = Officer.new
  end

  def edit
  end

  def create
    @officer = Officer.new(officer_params)
    @user = User.new(user_params)
    @officer.active = true
    if !@user.save
      @officer.valid?
      render action: 'new'
    else
      @officer.user_id = @user.id
      if @officer.save
        flash[:notice] = "Successfully created #{@officer.proper_name}."
        redirect_to officer_path(@officer)
      else
        flash[:notice] = "Unsuccessfully created #{@officer.proper_name}."
        render action: 'new'
      end
    end 
  end

  def update
    respond_to do |format|
      if @officer.update_attributes(officer_params)
        format.html { redirect_to @officer, notice: "Updated all information" }
        
      else
        format.html { render :action => "edit" }
        
      end
    end
  end

  def destroy
    if @officer.destroy
      flash[:notice] = "Successfully destroyed #{@officer.proper_name}."
      redirect_to officers_path
    else
      flash[:notice] = "You cannot destroy #{@officer.proper_name}."
      render action: 'show'
    end
  end

  def toggle_active_status
    @officer.toggle!(:active)
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

  def user_params      
    params.require(:officer).permit(:username, :password, :password_confirmation)
  end

end
