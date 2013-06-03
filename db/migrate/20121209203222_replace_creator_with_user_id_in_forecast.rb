class ReplaceCreatorWithUserIdInForecast < ActiveRecord::Migration
  def up
    remove_column :forecasts, :creator
    add_column :forecasts, :creator, :integer
  end

  def down
    remove_column :forecasts, :creator, :integer
    add_column :forecasts, :creator
  end
end
