class AddIndexToForecast < ActiveRecord::Migration
  def change
    change_table :forecasts do |t|
      t.references :milestone
    end
    add_index :forecasts, :milestone_id
  end
end
