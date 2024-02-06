# frozen_string_literal: true

class HabitsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_habit, only: %i[show edit update destroy toggle_availability]

  def new
    @habit = Habit.new
  end

  def create
    @habit = current_user.habits.new(habit_params)
    if @habit.save!
      respond_to do |format|
        format.turbo_stream
        format.html         { redirect_to root_path }
      end
    else
      render :new
    end
  end

  def destroy
    return unless @habit.destroy!

    @habits = current_user.habits.page(params[:page]).per(10)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@habit) }
      format.html         { redirect_to root_path }
    end
  end

  def toggle_availability
    if @habit.update(disabled: @habit.disabled ? false : true)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@habit) }
        format.html         { redirect_to root_path }
      end
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def habit_params
    params.require(:habit).permit(:name, :description, :habit_type_id, :disable, active_days: [])
  end

  def set_habit
    @habit = Habit.find(params[:id])
  end
end
