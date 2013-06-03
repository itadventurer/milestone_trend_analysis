# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: forecasts
#
#  id             :integer          not null, primary key
#  dateForecast   :date
#  budgetForecast :integer
#  comment        :string(255)
#  progress       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  milestone_id   :integer
#  spentBudget    :integer
#  createDate     :date
#  creator        :integer
#

class Forecast < ActiveRecord::Base
  attr_accessible :budgetForecast, :comment, :creator, :dateForecast, :progress, :spentBudget, :createDate

  belongs_to :milestone
  
  #testet. dass spentBudget eine Zahl größer oder gleich 0 ist
  validates :spentBudget, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # testet, ob dateForecast eingetragen wurde
  validates :dateForecast, presence: true
  
  # testet, dass budgetForecast eine Zahl größer oder gleich 0 ist 
  validates :budgetForecast, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # testet, dass progress eine Zahl zwischen 0 und 100 (Prozent) ist 
  validates :progress, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  # testet, ob creator (Ersteller des Forecast) vorhanden ist
  validates :creator, presence: true
  
  # testet, ob createDate eingetragen wurde
  validates :createDate, presence: true
  
  # ordnet die Forecasts nach aufsteigendem Erstelleungs-Datum
  default_scope order: 'createDate ASC'

  #gibt den Ersteller des Forecasts zurück
  def creatorname(user_id)
    User.find(user_id).username
  end

end
