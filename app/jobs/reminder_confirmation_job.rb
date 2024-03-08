class ReminderConfirmationJob < ApplicationJob
  queue_as :default

  def perform # rubocop:disable Metrics/AbcSize
    User.all.each do |user|
      next unless user.telegram_id && user.reminders.due_today.any? && user.active_hours?

      user.reminders.due_today.sample(1).each do |reminder|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: "Te acordaste de #{reminder.title}?",
                                  reply_markup: reply_markup(reminder))
      rescue StandardError => e
        Rails.logger.error "Failed to send message via Telegram: #{e.message}"
      end
    end
  end

  def reply_markup(reminder)
    {
      inline_keyboard: [
        [
          { text: " \xE2\x9C\x85 ", callback_data: "update_r:#{reminder.id}" },
          { text: " \xE2\x9D\x8C ", callback_data: 'update_r:no' }
        ]
      ]
    }
  end
end
