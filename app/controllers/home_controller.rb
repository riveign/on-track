# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    create_daily_habits_for_user(current_user)
    @habits = current_user.habits
    @daily_habits = find_daily_habits_for_user
  end
end
