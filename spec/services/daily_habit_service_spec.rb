require 'rails_helper'

RSpec.describe DailyHabitService do
  let(:user) { create(:user) }
  let(:service) { DailyHabitService.new(user) }

  describe '#find_habits_without_daily_habit' do
    context 'when user is present' do
      it 'returns habits without daily habits for today' do
        habit1 = create(:habit, user:)
        habit2 = create(:habit, user:, active_days: [])
        habit2.update(active_days: [Date.current.wday])

        habits_without_daily_habit = service.find_habits_without_daily_habit

        expect(habits_without_daily_habit).to include(habit2)
        expect(habits_without_daily_habit).not_to include(habit1)
      end
    end

    context 'when user is nil' do
      it 'returns nil' do
        service = DailyHabitService.new(nil)

        habits_without_daily_habit = service.find_habits_without_daily_habit

        expect(habits_without_daily_habit).to be_nil
      end
    end
  end

  describe '#create_daily_habits' do
    context 'when user is present' do
      it 'creates daily habits for habits without daily habits' do
        habit1 = create(:habit, user:)
        habit2 = create(:habit, user:, active_days: [])
        habit2.update(active_days: [Date.current.wday])

        expect do
          service.create_daily_habits
        end.to change(DailyHabit, :count).by(1)

        expect(DailyHabit.last.habit).to eq(habit2)
        expect(DailyHabit.last.user).to eq(user)
        expect(DailyHabit.last.done).to be_falsey
      end
    end

    context 'when user is nil' do
      it 'does not create daily habits' do
        service = DailyHabitService.new(nil)

        expect do
          service.create_daily_habits
        end.not_to change(DailyHabit, :count)
      end
    end
  end
end
