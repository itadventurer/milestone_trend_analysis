# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: milestones
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  project_id      :integer
#  date            :date
#  projectedBudget :integer
#

class Milestone < ActiveRecord::Base
  attr_accessible :name, :date, :forecasts_attributes, :projectedBudget
  
  # Einem Meilenstein sind Forecasts zugeordnet
  has_many :forecasts
  # Ein Meilenstein ist einem Projekt zugeordnet
  belongs_to :project
  accepts_nested_attributes_for :forecasts, allow_destroy: true

  # testet, ob Name,Datum und geplantes Budget vorhanden ist
  validates :name, presence: true
  validates :date, presence: true
  validates :projectedBudget, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # ordnet die Meilensteine nach aufsteigendem Datum
  default_scope order: 'date ASC'
  
  
	# Holt das Voraussichtliche Enddatum des Milestones
	# testet ob es mindestens 2 Forecasts gibt
	# wählt ersten und letzten Forecast aus
	# testet ob diese beiden Forecasts am selben Tag stattfanden
	# wenn ja -->gibt Vorhersage des letzten Forecast zurück
	# Algorithmus zur Berechnung des vorraussichtlichen Enddatum:
	# Aus dem letzten und ersten Forecast wird eine exponentielle Funktion erstellt welche das Vorraussichtliche Enddatum in Abhängigkeit zum Datum(Projektdauer) berechnet
	# Gleichsetzen dieser Funktion und der Datumslinie ergibt das berechnete Ende
	# Umstellen der Gleichung ergibt eine quadratische Gleichung, welche mit der quadratischen Lösungsformel (p-q Formel) gelöst wird
	# q=ursprüngliche geplante Projektdauer zum Quadrat
	# p= aktuelle Verschiebung des Projektendes zum Quadrat geteilt durch vergangene Projekttage, dazu wird 2 mal ursprüngliche Projektdauer addiert
	# "Wurzelteil" der p-q-Formel
	# Test, ob sich geplante Projektdauer erhöht hat
	# Berechnung der Projektdauer, wenn sich Projektdauer verlängert hat: p/2+Wurzel(p^2/4-q) 
	# Berechnung der Projektdauer, wenn sich Projektdauer verkürzt hat: p/2-Wurzel(p^2/4-q)  
	# Rückgabe des berechneten Enddatums (Startdatum +berechnete Projektdauer+ allgemeine Projektverzögerung)
	# wenn es nur einen Forecast (das heißt nur das ursprünglich geplante Datum) gibt, dann wird diese Vorhersage als berechnetes Datum zurückgegeben
	# gibt es keine Vorhersage, dann wird das EndDatum des Milestones+Verzögerung durch vorrangegangene Milestones zurückgegeben
	def getEstimatedEnd		
		if (self.forecasts.all.size >= 2) then	
			first = self.forecasts.all.first
			last = self.forecasts.all.last
			if (first.createDate == last.createDate)		
				return last.dateForecast
			end
			if (last.createDate >= last.dateForecast)
				return last.dateForecast
			end
			q = (first.dateForecast - first.createDate)**2			
			p = (((last.dateForecast - first.dateForecast)**2)/(last.createDate - first.createDate)) + (2*(first.dateForecast - first.createDate))			
			root = ((p**2)/4 - q)**(0.5)	
			if (last.dateForecast > first.dateForecast)			
				solution = 0.5*p + root		
			else 
				solution = 0.5*p - root
			end
			return (first.createDate + solution)	
		elsif (self.forecasts.all.size == 1)
			return self.forecasts.first.dateForecast	
		else
			delay = 0			
			project.milestones.each do |milestone|
				if milestone.forecasts.all.size >0
					if milestone.date<date
						delay = milestone.getEstimatedEnd-milestone.getInitialEnd
					end
				end
			end
			return date+delay
		end
	end
  
  # Holt das Voraussichtliche Budget des Milestones
	def getEstimatedBudget
		if (self.forecasts.all.size == 0) then
			return projectedBudget
		end
		if (self.forecasts.all.last.spentBudget == 0) || (self.forecasts.all.last.progress == 0)
			return self.forecasts.all.last.budgetForecast
		else
			budget = self.forecasts.all.last.spentBudget*((forecasts.all.last.progress.to_r/100)**(-1))
			return budget.to_i
		end
	end

	# Holt das geplante Ende des Milestones 
	def getInitialEnd
		date			
	end

	# Holt das Initialbudget des Milestones
	def getInitialBudget
		projectedBudget		
	end

	# Holt die Differenz von getInitialBudget und des verbrauchtem Budgets
	def getLeftBudget
		if (self.forecasts.all.size == 0) then
			return projectedBudget
		end
		left = forecasts.all.last.budgetForecast - forecasts.all.last.spentBudget
	end
	
	# bestimmt maximales und minmales Datum (wird für Grafik genutzt)
	def borderDate
	  maxForecast = Array.new
	  forecasts.each do |forecast|
	  maxForecast.push(forecast.dateForecast)
	  end
	  maxForecast.push(getEstimatedEnd)
	  return [maxForecast.sort.first,maxForecast.sort.last]
	end
	
	# Gibt Progress des Milestones zurück
	def getProgress
		if (self.forecasts.all.size == 0) then
			return 0
		end
		progress = forecasts.all.last.progress	
		return progress
	end
	
	# Gibt SpentBudget zurück
	def getSpentBudget
		if (self.forecasts.all.size == 0) then
			return 0
		end
		spentBudget = forecasts.all.last.spentBudget
		return spentBudget
	end
end
