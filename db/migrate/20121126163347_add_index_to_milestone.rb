class AddIndexToMilestone < ActiveRecord::Migration
  def change
    change_table :milestones do |t|
      t.references :project
    end
    add_index :milestones, :project_id
  end
end
