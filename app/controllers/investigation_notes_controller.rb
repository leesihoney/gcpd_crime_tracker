class InvestigationNotesController < ApplicationController
    before_action :check_login
    authorize_resource

  
    def new
      @investigation = Investigation.find(params[:investigation_id])
      @officer = Officer.find_by_user_id(current_user.id)
      @note = InvestigationNote.new(investigation_id: @investigation.id, officer_id: @officer.id)
    end
  
    def edit
      @note = InvestigationNote.find(params[:id])
    end
  
    def create
      @note = InvestigationNote.new(investigation_note_params)
      @note.date = Date.current.to_date
      if @note.save
        redirect_to investigation_path(@note.investigation), notice: "Successfully added note to #{@note.investigation.title}."
      else
        puts @note.date
        puts @note.investigation.title
        puts @note.officer.name
        puts @note.content
        @investigation = Investigation.find(params[:investigation_note][:investigation_id])
        @officer = Officer.find_by_user_id(current_user.id)
        render action: 'new', locals: { investigation: @investigation, officer: @officer }
      end
    end
  
    def update
      @note = InvestigationNote.find(params[:id])
      respond_to do |format|
        if @note.update_attributes(note_params)
          format.html { redirect_to @note, notice: "Updated information" }
    
        else
          format.html { render :action => "edit" }
    
        end
      end
    end
  
    private
    def investigation_note_params
      params.require(:investigation_note).permit(:investigation_id, :officer_id, :content, :date)
    end
  end
  