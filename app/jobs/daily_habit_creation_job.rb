class DailyHabitCreationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    users = User.all
    users.each do |user|
      DailyHabitService.new(user).create_daily_habits
      Rails.logger.info "Daily habits created for user #{user.id}"
    end
  end
end
