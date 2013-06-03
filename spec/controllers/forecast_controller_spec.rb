# -*- coding: iso-8859-1 -*-
require 'spec_helper'

describe ForecastController do
  
  # loggt Admin ein (siehe spec/support/controller_macros.rb)
  login_admin
  
  before :each do
    @project = FactoryGirl.create(:project)
    @milestone = FactoryGirl.create(:milestone, project: @project)
    @forecast = FactoryGirl.create(:forecast, milestone: @milestone)
  end
  
  #Wurde der Forecast korrekt in die Datenbank eingetragen?
  describe "GET #new" do
    it "renders the :new template" do
      get :new, project_id: @project, milestone_id: @milestone, id: @forecast 
      response.should render_template :new
    end	
  end
    
  #Wurde der Forecast korrekt geändert?
  describe "GET #edit" do
    it "assigns the requested forecast to @milestone" do
      get :edit, project_id: @project, milestone_id: @milestone, id: @forecast 
      assigns(:forecast).should eq(@forecast)
    end

    it "renders the :edit template" do
      get :edit, project_id: @project, milestone_id: @milestone, id: @forecast
      response.should render_template :edit
    end
  end
  
  #Wurden alle Forecasts korrekt gelöscht?
  describe "DELETE #destroy" do
    it "deletes the milestone" do
      expect {
        delete :destroy, project_id: @project, milestone_id: @milestone, id: @forecast      
      }.to change(Forecast,:count).by(-1)
    end
    
    it "redirects to milestone#show" do
      delete :destroy, project_id: @project, milestone_id: @milestone, id: @forecast 
      response.should redirect_to project_milestone_path(@project,@milestone)
    end
  end

end
