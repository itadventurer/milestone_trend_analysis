# -*- coding: utf-8 -*-
# Der Forecast–Controller modelliert die Vorhersagen der Projektleiter in der Datenbank
class ForecastController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # Neuen Forecast erstellen
  def new		
		@project = Project.find(params[:project_id])
    have_no_rights('project.no_rights') if cannot? :update, @project
		@milestone = Milestone.find(params[:milestone_id])
		@forecast = Forecast.new createDate: Date.today, budgetForecast: @milestone.getInitialBudget, dateForecast: @milestone.getInitialEnd, progress: 0, spentBudget: 0
		if (@milestone.forecasts.all.size >0 )
			@forecast.budgetForecast = @milestone.forecasts.last.budgetForecast
			@forecast.dateForecast = @milestone.forecasts.last.dateForecast
			@forecast.progress = @milestone.forecasts.last.progress
			@forecast.spentBudget = @milestone.forecasts.last.spentBudget			
		end
		self.bread
		add_crumb I18n.t('forecasts.new'), new_project_milestone_forecast_path(@project, @milestone, @forecast) 
	end
  
	# Bearbeitungsseite eines Forecasts
	def edit
		@project = Project.find(params[:project_id])
		@milestone = Milestone.find(params[:milestone_id])
		@forecast = Forecast.find(params[:id]) 
		self.bread
		add_crumb I18n.t('forecasts.edit'), edit_project_milestone_forecast_path(@project, @milestone, @forecast) 
	end
		
  # Erstellt einen Forecast
  def create
		@project = Project.find(params[:project_id])
		@milestone = Milestone.find(params[:milestone_id])
		@forecast = @milestone.forecasts.new(params[:forecast])
		@forecast.creator = current_user.id   
		# Nach Erstellen eines Forecasts gelangt man zurück zum Milestone
		if @forecast.save
			redirect_to project_milestone_path(@project,@milestone)
		else
			if @forecast.createDate==nil
				@forecast.createDate =Date.today
			end
			if @forecast.dateForecast==nil
				@forecast.dateForecast =@milestone.getInitialEnd
				if (@milestone.forecasts.all.size >0 )
					@forecast.dateForecast = @milestone.forecasts.last.dateForecast
				end
			end
			render 'new'
		end
  end

	# Aktualisiert einen Forecast
  def update
	@project = Project.find(params[:project_id])
	@milestone = Milestone.find(params[:milestone_id])
	@forecast = Forecast.find(params[:id]) 
		
    if @forecast.update_attributes(params[:forecast])
		flash[:success] = I18n.t('forecasts.updated')
		redirect_to project_milestone_path(@project,@milestone)
    else
		if @forecast.createDate==nil
				@forecast.createDate =Date.today
			end
			if @forecast.dateForecast==nil
				@forecast.dateForecast =@milestone.getInitialEnd
				if (@milestone.forecasts.all.size >0 )
					@forecast.dateForecast = @milestone.forecasts.last.dateForecast
				end
			end
			render 'new'
    end
  end

  # Löscht Forecast
  # Achtung aktuell ist es möglich alle Forecasts eines Projekts zu löschen ohne den Milestone/das Projekt zu löschen-> führt zum Fehler 
  def destroy
	@project = Project.find(params[:project_id])
	@milestone = Milestone.find(params[:milestone_id])
	@forecast = @milestone.forecasts.find(params[:id])
	@forecast.destroy
	flash[:success] = I18n.t('forecasts.deleted')
    redirect_to project_milestone_path(@project,@milestone)
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
		add_crumb @milestone.name, project_milestone_path(@project,@milestone)
	end
end
