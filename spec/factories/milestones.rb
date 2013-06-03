
FactoryGirl.define do
  
  # Milestone mit gültigen Attributen
  factory :milestone do |f|
    f.name "Analyse"
    f.date "24.12.2012"
    f.projectedBudget 500
  end
  
  # Milestone mit ungültigen Attributen
  factory :invalid_milestone, parent: :milestone do |f|
    f.name nil
    f.date nil
    f.projectedBudget nil
  end
end
