# -*- coding: iso-8859-1 -*-
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstName              :string(255)
#  lastName               :string(255)
#  isAdmin                :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  language               :string(255)      default("en")
#

class User < ActiveRecord::Base

  # Jedem User sind verschiedene Rollen zugeordnet, eine Rolle steht für eine Beziehung zu einem Projekt
  has_many :roles, :foreign_key => "user_id"
  # Projekte sind dem User über Rollen zugeordnet
  has_many :projects, :through => :roles
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstName, :isAdmin, :lastName, :language

  # Ordnet nach email
  default_scope order: 'email ASC'
  
  #Überprüft ob der User ein ProjectManager ist bezüglich eines Projektes
  def isManager?(project)
    if project.roles.find_by_user_id(self.id)
      return project.roles.find_by_user_id(self.id).name == "Project Manager"
    end
    false
  end

  #Überprüft ob der User ein Observer ist bezüglich eines Projektes
  def isObserver?(project)
    if project.roles.find_by_user_id(self.id)
      project.roles.find_by_user_id(self.id).name == "Observer"
    end
  end
  
 
  #Vollen Namen ausgeben, wenn nicht vorhanden, dann EMail Adresse
  def username
    if (self.firstName!='') && (self.lastName!='') 
      self.firstName+' '+self.lastName
    elsif self.firstName!='' 
      self.firstName
    elsif self.lastName!=''
      self.lastName
    else
      self.email
    end
  end

  #Muss noch implementiert werden
  def change_role?(project, word)
    project.roles.find_by_user_id(self.id).name != word
  end

end
