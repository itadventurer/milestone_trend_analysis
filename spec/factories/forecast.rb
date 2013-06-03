
FactoryGirl.define do
  factory :forecast do |f|
    f.comment "ForecastTest"
    f.dateForecast "24.12.2012"
	f.progress 10
	f.spentBudget 1000
	f.createDate Date.today
	f.budgetForecast 5000
	f.creator "TestUser"
  end
end
