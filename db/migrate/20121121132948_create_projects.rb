class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.date :projectStart
      t.string :state

      t.timestamps
    end
  end
end
