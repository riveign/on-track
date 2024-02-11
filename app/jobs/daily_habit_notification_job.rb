class DailyHabitNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.telegram_id && user.daily_habits.not_done.any?

      user.daily_habits.not_done.sample(1).each do |daily_habit|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: "Hoy no te olvides de #{daily_habit.habit.name}!")
      end
    end
  end
end
