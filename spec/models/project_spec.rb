# == Schema Information
#
# Table name: projects
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  projectStart :date
#  state        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Project do

	
	before do
		@date = Date.today
	   	@project = Project.new name: "Example   Project", projectStart: @date, state: "current" 
	end

	#Erstmal ein paar Standard-Tests
	subject { @project }

	it { should respond_to :name }
	it { should respond_to :projectStart }
	it { should respond_to :state }
  it { should respond_to :milestones }
	

	it { should be_valid }

	#Attribute testen/Wurde das Project korrekt in die Datenbank eingetragen?
	describe "when name is not present" do
		before { @project.name = " " }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			project2 = @project.dup
			project2.name = @project.name.upcase
			project2.save
		end

		it { should_not be_valid }
	end
  
  describe "when name is too short" do
		before { @project.name = "fooo" }
		it { should_not be_valid }
	end

  describe "when name is too long" do
		before { @project.name = "f" * 51 }
		it { should_not be_valid }
	end
  
	describe "when ProjectStart is not present" do
		before { @project.projectStart = nil }
		it { should_not be_valid }
	end

  describe "when state is not present" do
		before { @project.state = " " }
		it { should_not be_valid }
	end
  
  describe "when state has an invalid entry" do
		before { @project.state = "foo" }
		it { should_not be_valid }
	end

  
end
