# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def find_habits_without_daily_habit(user)
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day

    user.habits.left_outer_joins(:daily_habits)
        .where.not(id: DailyHabit.select(:habit_id).where(created_at: today_range))
  end

  def create_daily_habits_for_user(user)
    return unless user_signed_in?

    habits_without_daily_habit = find_habits_without_daily_habit(user)

    habits_without_daily_habit.each do |habit|
      habit.daily_habits.create!(user:, done: false)
    end
  end

  def find_daily_habits_for_user
    current_user.daily_habits.where(done: false,
                                    created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end
end
