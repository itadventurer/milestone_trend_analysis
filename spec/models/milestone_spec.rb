# == Schema Information
#
# Table name: milestones
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  project_id      :integer
#  date            :date
#  projectedBudget :integer
#

require 'spec_helper'

describe Milestone do
  	before do

    
    @project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)

    @milestone = FactoryGirl.create(:milestone)
        
    end
    
    subject { @milestone }
    it { should respond_to :name }
    it { should respond_to :date }
    it { should respond_to :projectedBudget }
        
  #Wurde der Milestone korrekt in die Datenbank eingetragen?
  it "has a valid factory" do 
    FactoryGirl.create(:milestone).should be_valid
  end
  
  describe "when name is invalid" do
    before { @milestone.name = nil }
    it { should_not be_valid }
  end
  
  describe "when it is invalid without a date" do
    before { @milestone.date = nil }
    it { should_not be_valid }
  end
  
  describe "when it is invalid without a projectedBudget" do
    before { @milestone.projectedBudget = nil}
    it { should_not be_valid }
  end
  
  describe "when projectedBudget lower than 0" do
    before { @milestone.projectedBudget = -10 }
    it { should_not be_valid }
  end
  
  describe "Initial End" do
    it "should be equal Date" do
      expect(@milestone.getInitialEnd).to eq @milestone.date
    end
  end
  
  describe "Initial Budget" do
    it "should be equal projectedBudget" do
      expect(@milestone.getInitialBudget).to eq @milestone.projectedBudget
    end
  end
  
  describe "Estimated Budget" do
    it "should be equal to projectedBudget without forecasts" do
     expect(@milestone.getEstimatedBudget).to eq @milestone.projectedBudget
    end
  end
  
  describe "Progress" do
    it "should be equal 0 without forecasts" do
      expect(@milestone.getProgress).to eq 0
    end
  end
  
  describe "Spent Budget" do
    it "should be equal 0 without forecasts" do
      expect(@milestone.getProgress).to eq 0
    end
  end
end
