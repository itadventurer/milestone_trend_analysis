# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstName              :string(255)
#  lastName               :string(255)
#  isAdmin                :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  language               :string(255)      default("en")
#

require 'spec_helper'

describe User do
	before do
	   @user = User.new email: "rofl@lol.xD", password: "foobar"
        @project = Project.new name: "Example   Project", projectStart: @date, state: "current" 
	end
	subject { @user }

	it { should respond_to :email }
	it { should respond_to :password }
	it { should be_valid }
	
  #Wurden die Userdaten korrekt eingetragen?
	describe "when email is not present" do
		before {@user.email=""}
		it {should_not be_valid}
	end
	
	describe "when password is not present" do
		before {@user.password=""}
		it {should_not be_valid}
	end
	
	describe "when password is too short" do
		before {@user.password="12345"}
		it {should_not be_valid}
	end
	
	describe "when email is already taken" do
		before do
			user2 = @user.dup
			user2.email = @user.email.upcase
			user2.save
		end
		it { should_not be_valid }
	end
	
	describe "when email is not a valid email" do
		describe "because she has no @" do
			before {@user.email="test.de"}
			it {should_not be_valid}
		end
		
		describe "because she has no ." do
			before {@user.email="test@lol"}
			it {should_not be_valid}
		end
		
	end

  describe "when user is no manager" do
    @user = FactoryGirl.build(:user)
    @project = FactoryGirl.build(:project)
    it "should not be a manager" do
      expect(@user.isManager?(@project)).to eq false
    end
  end

  describe "when user is a manager" do
    before do
      @user = FactoryGirl.create(:user)
      @project = FactoryGirl.create(:project)
      @role = Role.create project_id: @project.id, user_id: @user.id, name: "Project Manager"
    end
    it "should be a manager" do
      expect(@user.isManager?(@project)).to eq true
    end
  end

  describe "when user has no name at all" do
    @user = FactoryGirl.build(:user)
		before do
			@user.firstName= ""
			@user.lastName = ""
		end
    it "should give his mail" do
      expect(@user.username).to eq @user.email
    end
  end

  describe "when user has no first name" do
    @user = FactoryGirl.build(:user)
    before do
      @user.firstName= ""
      @user.lastName = "Laster"
    end
    it "should give his last name" do
      expect(@user.username).to eq @user.lastName
    end
  end

  describe "when user has no last name" do
    @user = FactoryGirl.build(:user)
    before do
      @user.firstName= "Firsty"
      @user.lastName = ""
    end
    it "should give his first name" do
      expect(@user.username).to eq @user.firstName
    end
  end

  describe "when user has first an last name" do
    @user = FactoryGirl.build(:user)
    before do
      @user.firstName= "Firsty"
      @user.lastName = "Lasty"
    end
    it "should give his full name" do
      expect(@user.username).to eq @user.firstName + " " + @user.lastName
    end
  end
end
