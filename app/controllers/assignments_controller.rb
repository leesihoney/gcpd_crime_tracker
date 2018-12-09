class AssignmentsController < ApplicationController
  before_action :check_login
  authorize_resource
  
  def new
    @assignment = Assignment.new
    unless params[:officer_id].nil?
      @officer    = Officer.find(params[:officer_id])
      @officer_investigations = @officer.assignments.current.map{|a| a.investigation }
    end
    unless params[:investigation_id].nil?
      @investigation = Investigation.find(params[:investigation_id])
      @investigation_officers = @investigation.assignments.current.map {|a| a.officer}
    end
  end
  
  def create
    puts params[:from]
    @assignment = Assignment.new(assignment_params)
    @assignment.start_date = Date.current
    if @assignment.save
      if params[:from] == "investigation"
        redirect_to investigation_path(@assignment.investigation)
      elsif params[:from] == "officer"
        redirect_to officer_path(@assignment.officer)
      end
      flash[:notice] = "Successfully added assignment."


    else
      puts params[:from] + " Failed!"
      if params[:from] == "investigation"
        @investigation = Investigation.find(params[:assignment[:officer_id]])
        render action: 'new', locals: { investigation: @investigation}
      else
        @officer = Officer.find(params[:assignment][:officer_id])
        render action: 'new', locals: { officer: @officer }
      end
    end
  end

  def terminate
    @assignment = Assignment.find(params[:id])
    @assignment.end_date = Date.current
    @assignment.save
    redirect_to officer_path(@assignment.officer)

  end

  private
  def assignment_params
    params.require(:assignment).permit(:investigation_id, :officer_id, :start_date, :end_date)
  end
end
