# == Schema Information
#
# Table name: forecasts
#
#  id             :integer          not null, primary key
#  dateForecast   :date
#  budgetForecast :integer
#  comment        :string(255)
#  progress       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  milestone_id   :integer
#  spentBudget    :integer
#  createDate     :date
#  creator        :integer
#

require 'spec_helper'

describe Forecast do

	
	before do

    
    @project = FactoryGirl.create(:project)
    @user = FactoryGirl.create(:user)

    @milestone = FactoryGirl.create(:milestone, project: @project)
    @forecast = FactoryGirl.create(:forecast, milestone: @milestone)
    #@forecast = Forecast.new dateForecast: "11.01.2013", spentBudget: 500, budgetForecast: 1000, comment: "foo", progress: 0, 
   #   creator: @user.id
  end

  subject { @forecast } 

  it { should respond_to :dateForecast }
  it { should respond_to :spentBudget }
  it { should respond_to :budgetForecast }
  it { should respond_to :comment }
  it { should respond_to :progress }
  it { should respond_to :creator } 

  it { should be_valid }

  #Wurde der Forecast korrekt in die Datenbank eingetragen?
  describe "when dateForecast is not present" do
    before { @forecast.dateForecast = " " }
    it { should_not be_valid }
  end

  describe "when budgetForecast is not present" do
    before { @forecast.budgetForecast = nil }
    it { should_not be_valid }
  end

  describe "when budgetForecast is not a number" do
    before { @forecast.budgetForecast = "foo" }
    it { should_not be_valid }
  end

  describe "when budgetForecast is too little" do
    before { @forecast.budgetForecast = -1 }
    it { should_not be_valid }
  end

  describe "when progress is not present" do
    before { @forecast.progress = nil }
    it { should_not be_valid }
  end

  describe "when progress is not a number" do
    before { @forecast.progress = "foo" }
    it { should_not be_valid }
  end

  describe "when progress is too little" do
    before { @forecast.progress = -1 }
    it { should_not be_valid }
  end

  describe "when progress is too big" do
    before { @forecast.progress = 101 }
    it { should_not be_valid }
  end

  describe "when creator is not present" do
    before { @forecast.creator = " " }
    it { should_not be_valid }
  end

  describe "when spentBudget is not present" do
    before { @forecast.spentBudget = nil }
    it { should_not be_valid }
  end

  describe "when spentBudget is too little" do
    before { @forecast.spentBudget = -1 }
    it { should_not be_valid }
  end

  describe "when spentBudget is not a number" do
    before { @forecast.spentBudget = "foo" }
    it { should_not be_valid }
  end

  describe "#creatorname" do
    #    expect(@forecast.creatorname(
  end

end
