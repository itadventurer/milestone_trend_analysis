# -*- coding: iso-8859-1 -*-
# == Schema Information
#
# Table name: projects
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  projectStart :date
#  state        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Project < ActiveRecord::Base
  attr_accessible :name, :projectStart, :state
  # Projekt sind Meilensteine zugeordnet
  has_many :milestones
  # Projekt sind über Rollen verschiedene User zugeordnet
  has_many :roles, :foreign_key => "project_id"
  has_many :users, :through => :roles
  
  # testet, ob Name des Milestones einzigartig und zwischen 5 und 50 Zeichen lang ist
	validates :name, 
		presence: true, 
		# Länge zwischen 5 und 50 Zeichen
		length: { minimum: 5, maximum:50 },
		# Name einzigartig
		uniqueness: { case_sensitive: false }
	  
	# testet, ob Projektstartdatum vorhanden ist
	validates :projectStart,
		presence: true

	# testet state
	validates :state,
		# testet, ob state vorhanden ist
		presence: true,
		# inclusion testet, dass state nur die Werte running, finished, aborted annehmen darf
		inclusion: { in: ["current", "finished", "aborted"] }

	# Ordnet Projekte nach Namen		
	default_scope order: 'name ASC'

	
	# Alias für project.projectStart
	# Grund: Generalisierung der Views, damit wir das template für Projects und Milestones benutzen können
	def getStartDate
		self.projectStart
	end

	# Holt Alle Projekte anhand des Status aus der Datenbank
	def getByState(state)
		Project.find_all_by_state(state)
	end
	
	# Holt alle Aktuellen Projekte aus der Datenbank
	def currentProjects
		self.getByState('current')
	end


	# Holt alle abgeschlossenen Projekte aus der Datenbank
	def finishedProjects
		self.getByState('finished')
	end

	# Holt alle abgebrochene Projekte aus der Datenbank
	def abortedProjects
		self.getByState('aborted')
	end

	# Zählt alle fertigen Milestones des Projects
	def countFinishedMilestones
	  getFinishedMilestones.count
	end

	# Zählt alle Milestones des Projects
	def countMilestones
    $a4='you'
    milestones.count
  end

  # Holt den ersten DateForecast des letzten Milestones des Projects
  def getInitialEnd
    dates = [projectStart]
    milestones.each do |milestone|
      dates.push(milestone.date)
    end
    dates.max
  end

  # Holt das Voraussichtliche Enddatum des Projects
  def getEstimatedEnd	
    date =[projectStart]
    milestones.each do |milestone|
      date.push(milestone.getEstimatedEnd)
    end
    return date.max		
  end

  # Holt die Summe der Initialbudgets der Milestones
  def getInitialBudget
    sumBudget = 0
    milestones.each do |milestone|
      sumBudget += milestone.getInitialBudget
    end
    sumBudget
  end

  # Holt die Differenz von getInitialBudget und des verbrauchtem Budget
  def getLeftBudget
    sumBudget = 0
    milestones.each do |milestone|
      sumBudget += milestone.getLeftBudget
    end
    sumBudget
  end

  # Holt die Summe der Voraussichtlichen Budgets
  def getEstimatedBudget
    sumBudget = 0
    milestones.each do |milestone|
      sumBudget += milestone.getEstimatedBudget
    end
    sumBudget
  end

  # holt die aktuellen Milestones
  def getCurrentMilestones
    current = []
    milestones.each do |milestone|
      if (milestone.getEstimatedEnd>=Date.current)
        current.push(milestone)
      end
    end
    current
  end

  # holt die beendeten Milestones
  def getFinishedMilestones
    finished = []
    milestones.each do |milestone|
      if(milestone.getEstimatedEnd<Date.current)
        finished.push(milestone)
      end
    end
    finished
  end

  # Gibt SpentBudget des Projects zurück
  def getSpentBudget
    spentBudget = 0
    milestones.each do |milestone|
      spentBudget += milestone.getSpentBudget
    end
    spentBudget
  end

  # Gibt Progress des Projects zurück
  def getProgress
    progress = 0
    if (self.getEstimatedBudget == 0)
      progress = 100
    else
      progress = 100*self.getSpentBudget/self.getEstimatedBudget
    end
    progress
  end


end
