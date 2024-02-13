class ReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform(reminder)
    return unless reminder.user.telegram_id

    Telegram.bot.send_message(chat_id: reminder.user.telegram_id,
                              text: reminder.telegram_notification)
  end
end
