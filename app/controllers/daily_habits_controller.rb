class DailyHabitsController < ApplicationController
  before_action :set_daily_habit, only: [:mark_done]

  def mark_done
    if @daily_habit.update(done: true)
      @daily_habits = find_daily_habits_for_user
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path }
      end
    else
      redirect_to root_path, alert: 'Unable to update the habit.'
    end
  end

  private

  def set_daily_habit
    @daily_habit = DailyHabit.find(params[:id])
  end
end
