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
  end
end
