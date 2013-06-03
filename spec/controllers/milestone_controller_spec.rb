# -*- coding: iso-8859-1 -*-
require 'spec_helper'

describe MilestoneController do
  
  # loggt Admin ein (siehe spec/support/controller_macros.rb)
  login_admin
  
  before :each do
    @project = FactoryGirl.create(:project)
    @milestone = FactoryGirl.create(:milestone, project: @project)
  end
  
  # Wurde der Milestone korrekt in die Datenbank eingetragen?  
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new milestone" do
        expect {
          post :create, project_id: @project, id: FactoryGirl.create(:milestone, project: @project)
        }.to change(Milestone, :count).by(1)
      end
      
      it "redirects to the new milestone" do
        post :create, project_id: @project, id: FactoryGirl.create(:milestone, project: @project)
        response.should redirect_to new_project_milestone_path
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new milestone" do
        expect{
          post :create, project_id: @project, id: FactoryGirl.attributes_for(:invalid_milestone, project: @project)
        }.to_not change(Milestone,:count)
      end
    
      it "re-renders the new method" do
        post :create, project_id: @project, id: FactoryGirl.attributes_for(:invalid_milestone, project: @project)
        response.should redirect_to controller: 'milestone', action: 'new'
      end
    end
  end
  
  describe "GET #new" do
    it "renders the :new template" do
      get :new, project_id: @project, id: @milestone
      response.should render_template :new
    end	
  end
    
  describe "GET #show" do
    it "assigns the requested milestone to @milestone" do
      get :show, project_id: @project, id: @milestone
      assigns(:milestone).should eq(@milestone)
    end

    it "renders the :show template" do
      get :show, project_id: @project, id: @milestone
      response.should render_template :show
    end
  end
  
  describe "GET #edit" do
    it "assigns the requested milestone to @milestone" do
      get :edit, project_id: @project, id: @milestone
      assigns(:milestone).should eq(@milestone)
    end
    
    it "renders the :edit template" do
      get :edit, project_id: @project, id: @milestone
      response.should render_template :edit
    end
  end
 
  #Wurden alle Milestones korrekt gelöscht? 
  describe "DELETE #destroy" do
    it "deletes the milestone" do
      expect {
        delete :destroy, project_id: @project, id: @milestone     
      }.to change(Milestone,:count).by(-1)
    end
    
    it "redirects to milestone#show" do
      delete :destroy, project_id: @project, id: @milestone 
      response.should redirect_to @project
    end
  end

end
