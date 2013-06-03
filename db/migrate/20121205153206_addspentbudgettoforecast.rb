class Addspentbudgettoforecast < ActiveRecord::Migration
  def change
    add_column :forecasts, :spentBudget, :integer
  end
end
