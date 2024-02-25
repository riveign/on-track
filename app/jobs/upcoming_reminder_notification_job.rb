class UpcomingReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.telegram_id && user.reminders.upcoming.any? && user.active_hours?

      user.reminders.upcoming.sample(1).each do |reminder|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: reminder.telegram_notification)
      end
    end
  end
end
