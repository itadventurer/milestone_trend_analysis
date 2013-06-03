# -*- coding: iso-8859-1 -*-
require 'spec_helper'

describe UserController do

  #Kï¿½nnen User nur von Administratoren gelï¿½scht werden?
  describe "DELETE #destroy" do
    # loggt User ein (siehe spec/support/controller_macros.rb)
    login_normal

    it "should not be able to delete the user" do
      expect {
        delete :destroy, id: @user     
      }.to change(User,:count).by(0)
    end
    
    it "should redirect to root" do
      delete :destroy, id: @user 
      response.should redirect_to root_path
    end
  end
  
  # loggt Admin ein (siehe spec/support/controller_macros.rb)
  login_admin
  
  describe "GET #index" do
    it "populates an array of users" do
      user = FactoryGirl.create(:user)
      get :index
      assigns(:users).should eq([user, @admin])
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
  
  #Wurde der User erfolgreich in die Datenbank eingetragen?
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new user" do
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to change(User, :count).by(1)
      end
      
      it "redirects to user#index" do
        post :create, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to users_path
      end
    end

    #Wurden die Userdaten korrekt eingetragen?
    context "with invalid attributes" do
      it "does not save the new user" do
        expect{
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
        }.to_not change(User,:count)
      end
    
      it "re-renders the new method" do
        post :create, user: FactoryGirl.attributes_for(:invalid_user)
        response.should render_template :new
      end
    end 
  end
  
  describe "GET #show" do
    it "assigns the requested user to @user" do
      user = FactoryGirl.create(:user)
      get :show, id: user
      assigns(:user).should eq(user)
    end

    it "renders the :show template" do
      get :show, id: FactoryGirl.create(:user)
      response.should render_template :show
    end
  end
  
  #Werden die Userdaten korrekt aktualisiert?
  describe "GET #edit" do
    it "assigns the requested user to @user"  do
      user = FactoryGirl.create(:user)
      get :edit, id: user
      assigns(:user).should eq(user)
    end
    
    it "renders the :edit template" do
      get :edit, id: FactoryGirl.create(:user)
      response.should render_template :edit
    end
  end
  
  #Werden die Userdaten korrekt aktualisiert?
  describe "PUT #update" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
  
    context "valid attributes" do
      it "located the requested @user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user)
        assigns(:user).should eq(@user)      
      end
  
      it "changes @user's attributes" do
        put :update, id: @user, 
        user: FactoryGirl.attributes_for(:user, firstName: "Foo", lastName: "Bar", email: "foo@bar.com", password: "foobar", 
                                                isAdmin: "false", language: "de")
        @user.reload
        @user.firstName.should eq("Foo")
        @user.lastName.should eq("Bar")
        @user.email.should eq("foo@bar.com")
        @user.password.should eq("foobar")
        @user.isAdmin.should eq(false)
        @user.language.should eq("de")
      end
  
      it "shows a flash message and redirects to the updated user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user)
        flash[:success].should_not be_nil
        response.should redirect_to @user
      end
    end
    
    context "invalid attributes" do
      it "located the requested @user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        assigns(:user).should eq(@user)      
      end
      
      it "does not change @user's attributes" do
        put :update, id: @user, 
        user: FactoryGirl.attributes_for(:user, firstName: "Foo", lastName: "Bar", email: nil, password: "foobar", 
                                                isAdmin: "false", language: "de")
        @user.reload
        @user.firstName.should_not eq("Foo")
        @user.lastName.should_not eq("Bar")
        @user.email.should eq("joris.rau@example.com")
        @user.password.should eq("foobar")
        @user.isAdmin.should eq(false)
        @user.language.should_not eq("de")
      end
      
      it "shows no flash message, but re-renders the edit method" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        flash[:success].should be_nil
        response.should render_template :edit
      end
    end
  end
  
  #Wurde der User korrekt aus der Datenbank entfernt und alle losen Enden gelöscht?
  describe "DELETE #destroy" do
    before :each do
      @user = FactoryGirl.create(:user)
    end
  
    it "deletes the user" do
      expect {
        delete :destroy, id: @user     
      }.to change(User,:count).by(-1)
    end
    
    it "redirects to user#index" do
      delete :destroy, id: @user 
      response.should redirect_to users_path
    end
  end

end
