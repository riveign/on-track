class ReminderConfirmationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user_can_recieve_message(user)

      user.reminders.due_today.sample(1).each do |reminder|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: I18n.t('telegram.reminders.question', reminder: reminder.title),
                                  reply_markup: reply_markup(reminder))
      rescue StandardError => e
        Rails.logger.error "Failed to send message via Telegram: #{e.message}"
      end
    end
  end

  private

  def user_can_recieve_message(user)
    user.telegram_id && user.reminders.due_today.any? && user.active_hours?
  end

  def reply_markup(reminder)
    {
      inline_keyboard: [
        [
          { text: emoji(:green_check), callback_data: "update_r:#{reminder.id}" },
          { text: emoji(:red_cross), callback_data: 'update_r:no' }
        ]
      ]
    }
  end
end
