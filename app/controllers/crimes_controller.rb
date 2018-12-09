class CrimesController < ApplicationController
  
  def index
    @active_crimes = Crime.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_crimes = Crime.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def new
    authorize! :new, @crime
    @crime = Crime.new
  end

  def edit
    authorize! :edit, @crime
    @crime = Crime.find(params[:id])
  end

  def create
    authorize! :create, @crime
    @crime = Crime.new(crime_params)
    if @crime.save
      puts "Passed!"
      redirect_to crimes_path, notice: "Successfully added #{@crime.name} to GCPD."
    else
      puts "Nyo"
      render action: 'new', notice: "Fail to add #{@crime.name} to GCPD."
    end
  end

  def update
    authorize! :update, @crime
    @crime = Crime.find(params[:id])
    respond_to do |format|
      if @crime.update_attributes(crime_params)
        format.html { redirect_to crimes_path, notice: "Updated information" }

      else
        format.html { render :action => "edit" }

      end
    end
  end



  private
  def crime_params
    params.require(:crime).permit(:name, :felony, :active)
  end
end
