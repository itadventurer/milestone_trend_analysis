# -*- coding: iso-8859-1 -*-
require 'spec_helper'

describe RoleController do

  # loggt Admin ein (siehe spec/support/controller_macros.rb)
  login_admin
  
  before :each do
    @project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)
    @role = FactoryGirl.create(:role, project: @project, user: @user)
  end
  
  describe "GET #index" do
    it "populates an array of users" do
      get :index, project_id: @project, user_id: @user, id: @role
      assigns(:users).should eq([@user])
    end

    it "renders the :index view" do
      get :index, project_id: @project, user_id: @user, id: @role
      response.should render_template :index
    end
  end

  #Wurde der User korrekt zu dem Project hinzugefügt?
  describe "GET #new" do
    it "renders the :new template" do
      get :new, project_id: @project, user_id: @user, id: @role
      response.should render_template :new
    end	
  end
  
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new role" do
        expect {
          post :create, project_id: @project, user_id: @user, role: FactoryGirl.attributes_for(:role)
        }.to change(Role, :count).by(1)
      end
      
      it "shows a flash message and redirects to role#index" do
        post :create, project_id: @project, user_id: @user, role: FactoryGirl.attributes_for(:role)
        flash[:success].should_not be_nil
        response.should redirect_to project_roles_path
      end
    end
  end
  
  describe "GET #show" do
    it "assigns the requested role to @role" do
      get :show, project_id: @project, user_id: @user, id: @role
      assigns(:role).should eq(@role)
    end

    it "renders the :show template" do
      get :show, project_id: @project, user_id: @user, id: @role
      response.should render_template :show
    end
  end

  #Werden die Rollen korrekt geändert?
  describe "GET #edit" do
    it "assigns the requested role to @role" do
      get :edit, project_id: @project, user_id: @user, id: @role
      assigns(:role).should eq(@role)
    end
    
    it "renders the :edit template" do
      get :edit, project_id: @project, user_id: @user, id: @role
      response.should render_template :edit
    end
  end
  
  #Werden die User korrekt aus dem Projekt gelöscht?
  describe "DELETE #destroy" do
    it "deletes the role" do
      expect {
        delete :destroy, project_id: @project, user_id: @user, id: @role    
      }.to change(Role,:count).by(-1)
    end
    
    it "shows a flash message and redirects to role#index" do
      delete :destroy, project_id: @project, user_id: @user, id: @role
      flash[:success].should_not be_nil
      response.should redirect_to project_roles_path
    end
  end

end
