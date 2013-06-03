# -*- coding: iso-8859-1 -*-
FactoryGirl.define do
  
  # Role mit gültigen Attributen
  factory :role do |f|
    f.name "Observer"
    f.user_id "1"
    f.project_id "1"
  end

  # Role mit gültigen Attributen als Manager
  factory :role2 do |f|
    f.name "Project Manager"
    f.user_id "1"
    f.project_id "1"
  end
 
  # Role mit ungültigen Attributen
  factory :invalid_role, parent: :role do |f|
    f.name nil
  end
end
