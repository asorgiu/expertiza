require 'rails_helper'

describe "PenaltyHelper" do
  before(:each) do
    @course_participant = create(:course_participant)
    @instructor = create(:instructor)
    @late_policy = create(:late_policy)
  end

  
  describe "#check_policy_with_same_name" do
    it "should return true when checking an existing policy name" do
      policy_exists = PenaltyHelper.check_policy_with_same_name(@late_policy.policy_name)
      expect(policy_exists).to be true
    end

    it "should return false when checking a non-existant policy name" do
      late_policy_delete = create(:late_policy)
      late_policy_name = late_policy_delete.policy_name
      LatePolicy.destroy(late_policy_delete.id)
      policy_exists = PenaltyHelper.check_policy_with_same_name(late_policy_name)
      expect(policy_exists).to be false
    end
  end
  
  describe "#update_calculated_penalty_objects" do
    it "should increase calculated penalty for day late assignment to policy maximum when changing policy time unit from Hour to Minute" do
      @late_policy.update_attributes(:penalty_unit => 'Minute')
      PenaltyHelper.update_calculated_penalty_objects(@late_policy)
      penalty_points = @calculated_penalty.penalty_points
      expect(penalty_points).to be == @late_policy.max_penalty
    end
  end
  
  describe "#calculate_penalty_minutes" do
    it "should return 1 when passed a 1 minute time difference and a penalty unit of 'Minute'" do
      @penalty_unit = 'Minute'
      time_difference = ((DateTime.now.in_time_zone) - (DateTime.now.in_time_zone - 1.minute)) 
      penalty_minutes = PenaltyHelper.calculate_penalty_minutes(time_difference)
      expect(penalty_minutes.round).to be == 1
    end
    
    it "should return 1 when passed a 1 hour time difference and a penalty unit of 'Hour'" do
      @penalty_unit = 'Hour'
      time_difference = ((DateTime.now.in_time_zone) - (DateTime.now.in_time_zone - 1.hour)) 
      penalty_minutes = PenaltyHelper.calculate_penalty_minutes(time_difference)
      expect(penalty_minutes.round).to be == 1
    end
    
    it "should return 1 when passed a 1 day time difference and a penalty unit of 'Day'" do
      @penalty_unit = 'Day'
      time_difference = ((DateTime.now.in_time_zone) - (DateTime.now.in_time_zone - 1.day)) 
      penalty_minutes = PenaltyHelper.calculate_penalty_minutes(time_difference)
      expect(penalty_minutes.round).to be == 1
    end
  end 

  it "has a valid factory" do
    factory = FactoryGirl.build(:late_policy)
    expect(factory).to be_valid
  end
end