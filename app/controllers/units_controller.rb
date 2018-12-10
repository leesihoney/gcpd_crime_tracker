class UnitsController < ApplicationController

  
  def index
    authorize! :index, @unit
    @active_units = Unit.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_units = Unit.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    authorize! :show, @unit
    @unit = Unit.find(params[:id])
    @officers = @unit.officers.active.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def new
    authorize! :new, @unit
    @unit = Unit.new
  end

  def edit
    authorize! :edit, @unit
    @unit = Unit.find(params[:id])
  end

  def create
    authorize! :create, @unit
    @unit = Unit.new(unit_params)
    if @unit.save
      redirect_to units_path, notice: "Successfully added #{@unit.name} to GCPD."
    else
      render action: 'new'
    end
  end

  def update
    authorize! :create, @unit
    @unit = Unit.find(params[:id])
    respond_to do |format|
      if @unit.update_attributes(unit_params)
        format.html { redirect_to @unit, notice: "Updated information" }

      else
        format.html { render :action => "edit" }

      end
    end
  end

  def toggle_active_status
    @unit = Unit.find(params[:id])
    if @unit.toggle!(:active)
      puts "Yes!"
    else
      puts "No!"
    end
  end

  def destroy
    @unit = Unit.find(params[:id])
    unit_name = @unit.name
    if @unit.destroy
      flash[:notice] = "Successfully destroyed #{unit_name}."
      redirect_to units_path
    else
      flash[:notice] = "You cannot destroy #{unit_name}."
      render action: 'show'
    end
  end



  private
  def unit_params
    params.require(:unit).permit(:name, :active)
  end
end
