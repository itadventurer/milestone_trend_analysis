# -*- coding: iso-8859-1 -*-
FactoryGirl.define do
  
  # Admin
  factory :admin, class: User do |f|
    f.firstName "Marcus"
    f.lastName "Hubrich"
    f.email "marcus.hubrich2@example.com"
    f.password "foobar"
    f.isAdmin "true"
    f.language "en"
  end
  
  # User mit gültigen Attributen
  factory :user do |f|
    f.firstName "Joris"
    f.lastName "Rau"
    f.email "joris.rau@example.com"
    f.password "foobar"
    f.isAdmin "false"
    f.language "en"
  end
  
  # User mit ungültigen Attributen
  factory :invalid_user, parent: :user do |f|
    f.firstName ""
    f.lastName ""
    f.email ""
    f.password ""
    f.isAdmin ""
    f.language "en"
  end
end
