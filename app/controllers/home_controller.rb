# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    create_daily_habits_for_user(current_user)
    @habits = current_user.habits
    @daily_habits = current_user.daily_habits.where(done: false,
                                                    created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end
end
