# -*- coding: iso-8859-1 -*-
# Kümmert sich um die Projekte
class ProjectController < ApplicationController

  include ApplicationHelper
  #Überprüft ob der User in nach Ability.rb dazu befugt ist
  load_and_authorize_resource :except => [:index, :new, :create]
  before_filter :authenticate_user!
  
	# Projektseite: Es werden alle eigenen Projekte angezeigt
	def index
    cookies.delete :allProjects
    @all_projects=false
    @projects=self.get_my_projects
	end
	
	# Projektseite: Es werden alle Projekte angezeigt (Adminbereich)
  def all
    cookies[:allProjects]=true
    @all_projects=true
    @projects={
      "current"=> Project.find_all_by_state('current'),
      "finished"=> Project.find_all_by_state('finished'),
      "aborted"=> Project.find_all_by_state('aborted')
    }
		self.bread
    authorize! :list_all, @projects
    render 'index'
  end

	# Neues Project erstellen
	def new
    have_no_rights('project.no_rights') if cannot? :create, Project
		@project = Project.new projectStart: Date.today
		self.bread
		add_crumb(I18n.t('projects.new'), new_project_path)
	end

	# Neues Project erstellen und speichern
	# Startstatus eines Projekts wird als laufend markiert
	# wenn Erstellung erfolgreich war, wird auf die Projektseite weitergeleitet
	# User, der Projekt erstellt hat wird automatisch mit dem Projekt verknüpft als Projektmanager
	def create
    have_no_rights('project.no_rights') if cannot? :create, Project
		@project = Project.new(params[:project])		
		@project.state='current'		
		if @project.save
			redirect_to @project
		else
			if @project.projectStart==nil
				@project.projectStart =Date.today
			end
			render 'new'
		end		
		@role = Role.create user_id: current_user.id, name: "Project Manager"
		@project.roles = [@role]
	end

	# Zeige Project an
	def show
		@project = Project.find(params[:id])
    have_no_rights('project.no_rights') if cannot? :read, @project
    @projects=self.get_my_projects
		self.bread
		add_crumb(@project.name, project_path(@project))
	end

	# Zeige die Bearbeitungsseite des Projects
	def edit
		@project = Project.find(params[:id])
    have_no_rights('project.no_rights') if cannot? :update, @project
		self.bread
		add_crumb(@project.name, project_path(@project))
		add_crumb(I18n.t('projects.edit'), edit_project_path(@project))
	end

	# Update Project
	def update
		@project = Project.find(params[:id])
    have_no_rights('project.no_rights') if cannot? :update, @project

		if @project.update_attributes(params[:project])
			flash[:success] = I18n.t('projects.updated')
			redirect_to @project
		else
			if @project.projectStart==nil
				@project.projectStart =Date.today
			end
			render 'new'
		end
	end

	# Destroy Project
	def destroy
		@project = Project.find(params[:id])
    have_no_rights('project.no_rights') if cannot? :destroy, @project
		@milestones = @project.milestones
           @forecasts = []
           @milestones.each do |milestone|
             @forecasts+= milestone.forecasts
           end
           @forecasts.each do |f|
             f.destroy
           end
		@milestones.each do |milestone|
			milestone.destroy
		end
		@roles = @project.roles
		@roles.each do |role|
			role.destroy
		end
		@project.destroy
		flash[:success] = I18n.t('projects.deleted')
		redirect_to(project_list_path) 
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
    @lol="fo"*210
    @a="<iframe width=\"#{@lol.length.to_s}\" height=\"315\" src=\"#{$f}\" frameborder=\"0\" allowfullscreen></iframe>"
	end
  
  # Gibt alle dem User zugeordneten Projekte nach Status sortiert zurück
  def get_my_projects

    if cookies[:allProjects]=='true'
      {
        "current"=> Project.find_all_by_state('current'),
        "finished"=> Project.find_all_by_state('finished'),
        "aborted"=> Project.find_all_by_state('aborted')
      }
    else
      {
        "current"=> User.find(current_user.id).projects.find_all_by_state('current'),
        "finished"=> User.find(current_user.id).projects.find_all_by_state('finished'),
        "aborted"=> User.find(current_user.id).projects.find_all_by_state('aborted')
      }
    end
  end
end
