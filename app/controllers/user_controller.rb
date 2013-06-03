# -*- coding: utf-8 -*-
# Kümmert sich um die Nutzerverwaltung
class UserController < ApplicationController
  include ApplicationHelper
	before_filter :authenticate_user!
  load_and_authorize_resource

  # User–Übersicht (adminbereich)
  def index
    :verify_admin
    @users = User.all
    self.bread
  end

  # Erstellungsseite
  def new
    @user = User.new
    self.bread
    add_crumb(I18n.t('users.new'),new_user_path)
  end

  # Erstellen eines neuen Users
  def create
    @user = User.new(params[:user])
    @user.attributes = params[:user]
    if @user.save
      flash[:success] = I18n.t('users.created')
      redirect_to users_path
    else
      self.bread
      add_crumb(I18n.t('users.new'),new_user_path)
      render 'new'
    end
  end

  # Bearbeitungsseite
  def edit
    @user = User.find(params[:id])
    self.bread
    add_crumb(I18n.t('users.edit'),edit_user_path(@user))
  end

  # Anzeige
  def show
    @user = User.find(params[:id])
    self.bread
    add_crumb(I18n.t('users.show', firstName:@user.firstName, lastName:@user.lastName),user_path(@user))
  end

  # Update der persönlichen Daten eines Users
  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update_attributes(params[:user])
      flash[:success] = I18n.t('users.update')
      redirect_to @user
    else
      self.bread
      add_crumb(I18n.t('users.edit'),edit_user_path(@user))
      render 'edit'
    end
  end

  # Löschen
  def destroy
    @user = User.find(params[:id])
    if (current_user == @user) and (@user.isAdmin) 		
      redirect_to users_path
      flash[:error] = I18n.t('users.admin_delete_self')
    else
			@roles = @user.roles
			@roles.each do |role|
				role.destroy
			end
      @user.delete
      flash[:success] = I18n.t('users.deleted')
      redirect_to users_path
    end
  end


  # Standard–Breadcrumbs
  def bread
    add_crumb(I18n.t('users.all'), users_path)
  end

end

#User als Admin authentifizieren, wenn nicht auf die Startseite schicken
def verify_admin
  :authenticate_user!
  have_no_rights('restricted area') unless current_user.isAdmin?
end
