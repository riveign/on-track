require 'rails_helper'

RSpec.describe DailyHabit, type: :model do
  describe 'validations' do
    let!(:user) { create(:user) }
    let!(:habit_type) { create(:habit_type) }

    it 'does not allow creating a new daily habit for the same habit on the same day' do
      habit = create(:habit, habit_type:, user:)
      daily_habit = build(:daily_habit, habit:, user:)
      expect(daily_habit.valid?).to be_falsy
    end

    it 'allows creating a new daily habit for the same habit on a different day' do
      habit = create(:habit, habit_type:, user:)
      daily_habit = build(:daily_habit, habit:, user:, created_at: Time.zone.now - 1.day)
      puts daily_habit.inspect
      expect(daily_habit.valid?).to be_truthy
    end
  end
end
