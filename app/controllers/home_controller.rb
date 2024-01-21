# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    create_daily_habits_for_user(current_user)
    @habits = Habit.where(user: current_user).page(params[:page]).per(10)
    @daily_habits = find_daily_habits_for_user
  end
end
