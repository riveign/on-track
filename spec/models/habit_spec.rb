require 'rails_helper'

RSpec.describe Habit, type: :model do
  describe 'callbacks' do
    describe 'before_create' do
      it 'sets disabled to false' do
        habit = create(:habit, disabled: true)
        expect(habit.disabled).to be false
      end
    end

    describe 'after_create' do
      it 'creates daily habits for the user' do
        habit = create(:habit)
        expect(habit.daily_habits.count).to eq 1
        expect(habit.daily_habits.first.done).to be false
      end
    end
  end
end
