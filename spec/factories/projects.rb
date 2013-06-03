
FactoryGirl.define do
  
  # Project mit gültigen Attributen
  factory :project do |f|
    f.name { Faker::Name.name }
    f.projectStart Date.today
    f.state "current"
  end
  
  # Project mit ungültigen Attributen
  factory :invalid_project, parent: :project do |f|
    f.name nil
    f.projectStart nil
  end
end




