# -*- coding: iso-8859-1 -*-
# Der MilestoneController kümmert sich um die Meilensteine
class MilestoneController < ApplicationController
  before_filter :authenticate_user!
  include ApplicationHelper

  # Erstellungsseite für einen Milestone
  def new
    @project = Project.find(params[:project_id])
    have_no_rights('project.no_rights') if cannot? :update, @project
    @milestone = Milestone.new projectedBudget: 0
    @milestone.created_at = Date.today
		@milestone.date= Date.today
    self.bread
    add_crumb I18n.t('milestones.new'), new_project_milestone_path(@project,@milestone)
  end

  # Erstellt einen neuen Milestone
  # Beim erfolgreichen Erstellen des Milestones erfolgt die Weiterleitung zum Milestone
  def create
    @project = Project.find(params[:project_id])
    have_no_rights('project.no_rights') if cannot? :update, @project
    @milestone = @project.milestones.new(params[:milestone])   
    if @milestone.save
      redirect_to project_milestone_path(@project, @milestone)
    else
			if @milestone.date==nil
				@milestone.date =Date.today
			end
			render 'new'
    end
  end

  # Zeigt den aktuellen Milestone an
  def show
    @project = Project.find(params[:project_id])
    have_no_rights('project.no_rights') if cannot? :read, @project
    @milestone = @project.milestones.find(params[:id])
    self.bread
    add_crumb @milestone.name, project_milestone_path(@project, @milestone)
    respond_to do |format|
      format.html
      format.svg do
        if params[:type]=='png'
          svg_file = render_to_string 
          o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
          string  =  (0...5).map{ o[rand(o.length)] }.join
          graph_link= "/images/charts/#{string}"
          path="#{Rails.root}/public#{graph_link}"
          File.open("#{path}.svg", 'w') {|f| f.write(svg_file) }
          `rsvg-convert "#{path}.svg" > "#{path}.png" && rm "#{path}.svg"` 
          redirect_to "#{graph_link}.png"
          
        end
      end
    end
  end

  # Zeigt die Bearbeitungsseite des Milestones an
  def edit
    @project = Project.find(params[:project_id])
    @milestone = @project.milestones.find(params[:id])
    have_no_rights('project.no_rights') if cannot? :update, @milestone
    self.bread
    add_crumb @milestone.name, project_milestone_path(@project, @milestone)
    add_crumb I18n.t('milestones.edit'), edit_project_milestone_path(@project,@milestone)
  end

  # Updated Milestone
  def update
    @project = Project.find(params[:project_id])
    @milestone = @project.milestones.find(params[:id])
    have_no_rights('project.no_rights') if cannot? :update, @milestone
    if @milestone.update_attributes(params[:milestone]) 
      flash[:success] = I18n.t('milestones.updated')
      redirect_to project_milestone_path(@project, @milestone)
    else
      if @milestone.date==nil
				@milestone.date =Date.today
			end
			render 'new'
    end
  end

  # Löscht Milestone
  def destroy
    @project = Project.find(params[:project_id])
    @milestone = @project.milestones.find(params[:id])
    if cannot? :destroy, @milestone
      have_no_rights('project.no_rights') 
    else 
      @forecasts = @milestone.forecasts
      @forecasts.each do |forecast|
        forecast.destroy
      end
      @milestone.destroy
      flash[:success] = I18n.t('milestones.deleted')
      redirect_to @project
    end
  end

  # generiert die Standard-Breadcrumbs für den Milestone
  def bread
		if @all_projects || cookies[:allProjects]
      i18n='all'
      path=project_list_path
    else
      i18n='my'
      path=projects_path
    end
    add_crumb(I18n.t('projects.'+i18n),path)
    add_crumb @project.name, project_path(@project)
  end

end
