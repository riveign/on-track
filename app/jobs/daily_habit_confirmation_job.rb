class DailyHabitConfirmationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.telegram_id && user.daily_habits_for_today.any? && user.active_hours?

      user.daily_habits_for_today.sample(1).each do |daily_habit|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: "Hoy hiciste #{daily_habit.habit.name}?",
                                  reply_markup: reply_markup(daily_habit))
      end
    end
  end

  def reply_markup(daily_habit)
    {
      inline_keyboard: [
        [
          { text: 'Si', callback_data: "update_dh:#{daily_habit.id}" },
          { text: 'No', callback_data: 'update_dh:no' }
        ]
      ]
    }
  end
end
