class ReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.telegram_id && user.reminders.upcoming.any?

      user.reminders.upcoming.sample(1).each do |reminder|
        days_until_due = (reminder.due_date.to_date - Date.today).to_i
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: "No te olvides de #{reminder.title} para dentro de #{days_until_due} dias!")
      end
    end
  end
end
