class HomeController < ApplicationController
  def index
    if user_signed_in?
      @habits = current_user.habits
    end
  end
end
