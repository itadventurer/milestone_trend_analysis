# -*- coding: iso-8859-1 -*-
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Role do
	before do
	   @user = FactoryGirl.build(:user)
        @project = FactoryGirl.build(:project)
        @role= FactoryGirl.build(:role)
	end
	subject { @role }
  
	it { should respond_to :name }
	it { should be_valid }

  #Wurde der User korrekt zu dem Project hinzugefügt?
  describe "when name is not present" do
    before {@role.name= nil }
    it {should_not be_valid}
  end

  describe "when name not an accepted name" do
    before {@role.name= "Karl Heinz" }
    it {should_not be_valid}
  end

  describe "when name is Project Manager" do
    before {@role.name= "Project Manager" }
    it {should be_valid}
  end

  describe "when name is Observer" do
    before {@role.name= "Observer" }
    it {should be_valid}
  end

 describe "when user id is not present" do
    before {@role.user_id= nil }
    it {should_not be_valid}
  end

 describe "when project id is not present" do
    before {@role.project_id= nil }
    it {should_not be_valid}
  end

end
