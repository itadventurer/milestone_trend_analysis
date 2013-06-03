# -*- coding: utf-8 -*-
# Kümmert sich um die Rollen
class RoleController < ApplicationController
  include ApplicationHelper
	before_filter :authenticate_user!
  load_and_authorize_resource :except => [:index]

  # User–Übersicht
  def index 
    @project=Project.find(params[:project_id])
    if !(current_user.isManager?(@project) ||current_user.isObserver?(@project))
       :authenticate_user!
       have_no_rights('restricted area') unless current_user.isAdmin?
    end		
    @users = @project.users
    self.bread
  end

  # Erstellungsseite
  def new
    @project=Project.find(params[:project_id])
    @role=Role.new
    userArray = User.all.select { |h| !@project.users.include? h}
    @users= userArray.sort_by {|obj| obj.email}
    self.bread
    add_crumb(I18n.t('roles.add'),new_project_role_path)
  end

  # Zuweisen einer neuen Rolle
  def create
    @project=Project.find(params[:project_id])
    @role=Role.new user_id: params[:role][:user_id], project_id: params[:project_id], name: params[:role][:name]
    if @role.save
      flash[:success] = I18n.t('roles.created')
      redirect_to project_roles_path
    else
      self.bread
      add_crumb(I18n.t('roles.new'),new_project_role_path)
      render 'new'
    end
  end

  # Bearbeitungsseite
  def edit
    @project=Project.find(params[:project_id])
    @role = Role.find(params[:id])
    @user= User.find(@role.user_id)
    self.bread
    add_crumb(I18n.t('roles.edit'),edit_project_role_path(@role))
  end

  # Anzeige
  def show
    @project=Project.find(params[:project_id])
    @role = Role.find(params[:id])
    @user= User.find(@role.user_id)
    self.bread
    add_crumb(I18n.t('users.show', firstName:@user.firstName, lastName:@user.lastName), project_roles_path(@role))
  end

  # Update der persönlichen Daten eines Users
  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:success] = I18n.t('roles.update')
      redirect_to project_roles_path
    else
      self.bread
      add_crumb(I18n.t('roles.edit'),edit_project_role_path(@role))
      render 'edit'
    end
  end

  # Rolle Löschen
  def destroy
    @role = Role.find(params[:id])
	  @role.destroy
    flash[:success] = I18n.t('roles.delete')
    redirect_to project_roles_path
  end


  # Standard–Breadcrumbs
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
    add_crumb(I18n.t('roles.all'), project_roles_path)
  end

end
