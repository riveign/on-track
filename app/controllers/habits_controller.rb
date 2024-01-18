class HabitsController < ApplicationController
  before_action :authenticate_user!

  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.new(habit_params)
    if @habit.save
      redirect_to habits_path, notice: 'Habit was successfully created.'
    else
      render :new
    end
  end

  private

  def habit_params
    params.require(:habit).permit(:name, :description, :habit_type_id)
  end
end
