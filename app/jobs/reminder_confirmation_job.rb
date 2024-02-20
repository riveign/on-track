class ReminderConfirmationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.telegram_id && user.reminders.due_today.any?

      user.reminders.due_today.sample(1).each do |reminder|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: "Te acordaste de #{reminder.title}?",
                                  reply_markup: reply_markup(reminder))
      end
    end
  end

  def reply_markup(reminder)
    {
      inline_keyboard: [
        [
          { text: 'Si', callback_data: "update_r:#{reminder.id}" },
          { text: 'No', callback_data: 'update_r:no' }
        ]
      ]
    }
  end
end
