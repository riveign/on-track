class DailyHabitCreationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.all.each do |user|
      next unless user.telegram_id && user.midnight?

      DailyHabitService.new(user).create_daily_habits
    end
  end
end
