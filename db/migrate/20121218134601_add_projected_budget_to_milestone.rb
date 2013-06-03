class AddProjectedBudgetToMilestone < ActiveRecord::Migration
  def change
	add_column :milestones, :projectedBudget, :integer
  end
end
