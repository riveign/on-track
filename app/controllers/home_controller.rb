# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    return unless user_signed_in?

    @habits = current_user.habits
  end
end
