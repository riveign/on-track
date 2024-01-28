class UpdateDailyHabitJob < ApplicationJob
  queue_as :default

  def perform(daily_habit:, user:)
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: "Congratulations! #{daily_habit.habit.name} is offically done")
  end
end
