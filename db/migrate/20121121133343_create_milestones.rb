class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :name
      t.integer :position
	   
      t.timestamps
    end
  end
end
