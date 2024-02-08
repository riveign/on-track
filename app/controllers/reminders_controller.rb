class RemindersController < ApplicationController
  before_action :set_reminder, only: %i[show edit update destroy mark_done]

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = current_user.reminders.new(reminder_params)
    if @reminder.save!
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path }
      end
    else
      render :new
    end
  end

  def mark_done
    return unless @reminder.update(done: true)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  private

  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(:title, :name, :due_date, :description)
  end
end
