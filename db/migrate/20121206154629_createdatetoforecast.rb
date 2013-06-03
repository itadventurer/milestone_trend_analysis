class Createdatetoforecast < ActiveRecord::Migration
  def change
    add_column :forecasts, :createDate , :date 
  end
end
