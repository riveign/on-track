class DailyHabitsController < ApplicationController
  before_action :set_daily_habit, only: [:mark_done]

  def mark_done
    if @daily_habit.update(done: true)
      @daily_habits = find_daily_habits_for_user
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('daily_habits_list', partial: 'daily_habits/daily_habits_list',
                                                                         locals: { daily_habits: @daily_habits })
        end
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
