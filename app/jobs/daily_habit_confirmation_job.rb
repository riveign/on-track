class DailyHabitConfirmationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.telegram_id && user.daily_habits_for_today.any?

      user.daily_habits_for_today.sample(1).each do |daily_habit|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: "Hoy hiciste #{daily_habit.habit.name}?",
                                  reply_markup: {
                                    inline_keyboard: [
                                      [
                                        { text: 'Si', callback_data: daily_habit.id.to_s },
                                        { text: 'No', callback_data: 'no' }
                                      ]
                                    ]
                                  })
      end
    end
  end
end
