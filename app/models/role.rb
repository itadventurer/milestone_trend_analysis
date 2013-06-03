# -*- coding: iso-8859-1 -*-
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# eine Rolle stellt die Beziehung zwischen Projekt und User her	
class Role < ActiveRecord::Base
  attr_accessible :name, :project_id, :user_id
  belongs_to :project
  belongs_to :user

  #testet. dass name, user_id und project_id vorhanden sind und zusätzlich ob ein valider Name eingetragen wurde
  validates :name, presence: true, inclusion: { in: ["Observer", "Project Manager"] }
  validates :user_id, presence: true
  validates :project_id, presence: true

end
