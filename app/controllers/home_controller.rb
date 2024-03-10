# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    DailyHabitService.new(current_user).create_daily_habits
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
    @daily_habit_chart = DailyHabitGraphService.new(@current_user).calculate
    render turbo_stream: turbo_stream.replace('content_frame', partial: 'habits_actions',
                                                               locals: { habits: @habits })
  end

  def new_reminder_or_habit
    @habits = current_user.habits
    render turbo_stream: turbo_stream.replace('content_frame', partial: 'new_reminder_or_habit')
  end

  def calendar # rubocop:disable Metrics/AbcSize
    @selected_date = (params[:date].present? ? Date.parse(params[:date]) : Date.today).all_day
    @daily_habits = current_user.daily_habits.where(created_at: @selected_date)
    @reminders = current_user.reminders.where(due_date: @selected_date)
    @daily_rating = current_user.daily_ratings.find_by(rated_on: @selected_date)
    render turbo_stream: turbo_stream.replace('content_frame', partial: 'calendar')
  end
end
