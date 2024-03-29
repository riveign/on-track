class ReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform(reminder)
    return unless reminder.user.telegram_id && reminder.user.active_hours?

    Telegram.bot.send_message(chat_id: reminder.user.telegram_id,
                              text: reminder.telegram_notification)
  rescue StandardError => e
    Rails.logger.error "Failed to send message via Telegram: #{e.message}"
  end
end
