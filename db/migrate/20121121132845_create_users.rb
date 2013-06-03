class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.boolean :isAdmin

      t.timestamps
    end
  end
end
