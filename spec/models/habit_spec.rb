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
    describe '#streak' do
      let(:user) { create(:user) }
      let(:habit) { create(:habit, user:) }

      context 'when it has been completed for 5 days' do
        before do
          5.times do |n|
            create(:daily_habit, habit:, done: true, created_at: (n + 1).days.ago, user:)
          end
        end
        it 'calculates the streak count' do
          expect(habit.streak).to eq 5
        end
      end

      context 'when its has not been completed for 1 day' do
        before do
          create(:daily_habit, habit:, done: true, created_at: 2.days.ago, user:)
          create(:daily_habit, habit:, done: false, created_at: 1.day.ago, user:)
        end
        it 'calculates the streak count' do
          expect(habit.streak).to eq 0
        end
      end
    end
  end
end
