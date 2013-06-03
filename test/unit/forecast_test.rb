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

require 'test_helper'

class ForecastTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
