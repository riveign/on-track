# rubocop:disable Metrics/BlockLength
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
      it 'creates daily habits for the user if today is active' do
        habit = create(:habit, active_days: [(Date.current.wday.zero? ? 7 : Date.current.wday).to_s])
        expect(habit.daily_habits.count).to eq 1
        expect(habit.daily_habits.first.done).to be false
      end

      it 'creates daily habits for the user if today is active' do
        habit = create(:habit)
        expect(habit.daily_habits.count).to eq 1
        expect(habit.daily_habits.first.done).to be false
      end

      it 'does not creates daily habits for the user if today is not active' do
        habit = create(:habit, active_days: [])
        expect(habit.daily_habits.count).to eq 0
      end
    end
    describe '#streak' do
      let(:user) { create(:user) }
      let(:habit) { create(:habit, user:, created_at: (5 + 2).days.ago) }

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
  describe '#accomplishment_percentage' do
    let(:user) { create(:user) }
    let(:inactive_habit) { create(:habit, user:) }
    let(:habit) { create(:habit, user:) }

    context 'when there are no recent daily habits' do
      it 'returns 0' do
        expect(inactive_habit.accomplishment_percentage).to eq 0
      end
    end

    context 'when there are recent daily habits' do
      let!(:recent_habit_1) { create(:daily_habit, habit:, done: true, user:, created_at: 2.days.ago) }
      let!(:old_habit) { create(:daily_habit, habit:, done: false, user:, created_at: 31.days.ago) }
      let!(:old_habit2) { create(:daily_habit, habit:, done: false, user:, created_at: 32.days.ago) }

      it 'calculates the accomplishment percentage' do
        expect(habit.accomplishment_percentage).to eq 50.0
      end

      it 'calculates the accomplishment percentage for a specific number of days' do
        expect(habit.accomplishment_percentage(33)).to eq 25.0
      end
    end
  end
end
