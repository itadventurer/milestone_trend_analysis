class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|
      t.date :dateForecast
      t.integer :budgetForecast
      t.string :comment
      t.integer :progress
      t.string :creator

      t.timestamps
    end
  end
end
