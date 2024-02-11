# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    DailyHabitService.new(current_user).create_daily_habits
    @habits = Habit.where(user: current_user)
    @daily_habits = current_user.daily_habits_for_today
    @reminders = current_user.reminders.upcoming
  end

  def todays_reminders_and_habits
    @daily_habits = current_user.daily_habits_for_today
    @reminders = current_user.reminders.upcoming
    render turbo_stream: turbo_stream.replace('content_frame', partial: 'daily_actions',
                                                               locals: { daily_habits: @daily_habits,
                                                                         reminders: @reminders })
  end

  def list_all_habits
    @habits = current_user.habits
    render turbo_stream: turbo_stream.replace('content_frame', partial: 'habits_actions',
                                                               locals: { habits: @habits })
  end

  def new_reminder_or_habit
    render turbo_stream: turbo_stream.replace('content_frame', partial: 'new_reminder_or_habit')
  end
end
