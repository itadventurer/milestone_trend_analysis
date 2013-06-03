class ReplacePositionWithDateInMilestone < ActiveRecord::Migration
  def up
    remove_column :milestones, :position
  end

  def down
    add_column :milestones, :date, :date
  end
end
