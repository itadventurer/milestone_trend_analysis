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

require 'test_helper'

class MilestoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
