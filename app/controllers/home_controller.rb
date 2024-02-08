# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    DailyHabitService.new(current_user).create_daily_habits
    @habits = Habit.where(user: current_user)
    @daily_habits = current_user.daily_habits_for_today
    @reminders = current_user.reminders.upcoming
  end
end
