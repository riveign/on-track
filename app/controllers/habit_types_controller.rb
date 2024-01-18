class HabitTypesController < ApplicationController
  def new
    @habit_type = HabitType.new
  end

  def create
    @habit_type = HabitType.new(habit_type_params)
    if @habit_type.save
      redirect_to root_path, notice: 'Habit type was successfully created.'
    else
      render :new
    end
  end

  private

  def habit_type_params
    params.require(:habit_type).permit(:name)
  end
end
