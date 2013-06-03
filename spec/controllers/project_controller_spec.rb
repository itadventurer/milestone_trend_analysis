# -*- coding: iso-8859-1 -*-
require 'spec_helper'

describe ProjectController do

  
  #Kann nur der Administrator das Project löschen?
  describe "DELETE #destroy" do
    
    # loggt User ein (siehe spec/support/controller_macros.rb)
    login_normal  
    
    before :each do
      @project = FactoryGirl.create(:project)
    end
  
    it "is not able to delete the project" do
      expect {
        delete :destroy, id: @project     
      }.to change(Project,:count).by(0)
    end
    
    it "redirects to root" do
      delete :destroy, id: @project 
      response.should redirect_to root_path
    end
  end

  # loggt Admin ein (siehe spec/support/controller_macros.rb)
  login_admin
  
  describe "GET #all" do
    it "populates an array of projects" do
      project = FactoryGirl.create(:project)
      get :all
      assigns(:projects).should eq("current" =>[project], "finished" =>[], "aborted" =>[])
    end
      
    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end
  
  describe "GET #new" do      
    it "renders the :new template" do
      get :new
      response.should render_template :new
    end	
  end

  #Wurde das Project korrekt in die Datenbank eingetragen?
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new project" do
        expect {
          post :create, project: FactoryGirl.attributes_for(:project)
        }.to change(Project, :count).by(1)
      end
      
      it "redirects to the new project" do
        post :create, project: FactoryGirl.attributes_for(:project)
        response.should redirect_to Project.last
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new project" do
        expect{
          post :create, project: FactoryGirl.attributes_for(:invalid_project)
        }.to_not change(Project,:count)
      end
    
      it "re-renders the new method" do
        post :create, project: FactoryGirl.attributes_for(:invalid_project)
        response.should redirect_to controller: 'project', action: 'new'
      end
    end 
  end
  
  describe "GET #show" do
    it "assigns the requested project to @project" do
      project = FactoryGirl.create(:project)
      get :show, id: project
      assigns(:project).should eq(project)
    end

    it "renders the :show template" do
      get :show, id: FactoryGirl.create(:project)
      response.should render_template :show
    end
  end
  
  #Wurde das Project korrekt geändert?
  describe "GET #edit" do
    it "assigns the requested project to @project"  do
      project = FactoryGirl.create(:project)
      get :edit, id: project
      assigns(:project).should eq(project)
    end
    
    it "renders the :edit template" do
      get :edit, id: FactoryGirl.create(:project)
      response.should render_template :edit
    end
  end
  
  describe "PUT #update" do
    before :each do
      @project = FactoryGirl.create(:project)
    end
  
    context "valid attributes" do
      it "located the requested @project" do
        put :update, id: @project, project: FactoryGirl.attributes_for(:project)
        assigns(:project).should eq(@project)      
      end
  
      #Wurde der Status korrekt geändert?
      it "changes @project's attributes" do
        put :update, id: @project, 
          project: FactoryGirl.attributes_for(:project, name: "Example Project", projectStart: Date.today, state: "finished")
        @project.reload
        @project.name.should eq("Example Project")
        @project.projectStart.should eq(Date.today)
        @project.state.should eq("finished")
      end
  
      it "shows a flash message and redirects to the updated project" do
        put :update, id: @project, project: FactoryGirl.attributes_for(:project)
        flash[:success].should_not be_nil
        response.should redirect_to @project
      end
    end
    
    context "invalid attributes" do
      it "located the requested @project" do
        put :update, id: @project, project: FactoryGirl.attributes_for(:invalid_project)
        assigns(:project).should eq(@project)      
      end
  
      it "does not change @project's attributes" do
        put :update, id: @project, 
          project: FactoryGirl.attributes_for(:project, name: "Example Project", projectStart: nil, state: "finished")
        @project.reload
        @project.name.should_not eq("Example Project")
        @project.projectStart.should eq(Date.today)
        @project.state.should_not eq("finished")
      end
  
      it "shows no flash message, but re-renders the edit method" do
        put :update, id: @project, project: FactoryGirl.attributes_for(:invalid_project)
        flash[:success].should be_nil
        response.should redirect_to controller: 'project', action: 'edit'
      end
    end
  end
  
  #Wurde das Projekt korrekt gelöscht?
  describe "DELETE #destroy" do
    before :each do
      @project = FactoryGirl.create(:project)
      @milestone = FactoryGirl.create(:milestone, project: @project)
      @forecast = FactoryGirl.create(:forecast, milestone: @milestone)
    end
  
    it "deletes the project" do
      expect {
        delete :destroy, id: @project     
      }.to change(Project,:count).by(-1)
    end
    
    it "redirects to project#index" do
      delete :destroy, id: @project 
      response.should redirect_to project_list_path
    end

    it "deletes the milestone" do
      expect {
        delete :destroy, id: @project     
      }.to change(Milestone,:count).by(-1)
    end

    it "deletes the forecast" do
      expect {
        delete :destroy, id: @project     
      }.to change(Forecast,:count).by(-1)
    end
  end

end
