class DailyHabitNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user.telegram_id && user.daily_habits_for_today.any? && user.active_hours?

      user.daily_habits_for_today.sample(1).each do |daily_habit|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: "Hoy no te olvides de #{daily_habit.habit.name}! \xF0\x9F\x92\xAA	")
      rescue StandardError => e
        Rails.logger.error "Failed to send message via Telegram: #{e.message}"
      end
    end
  end
end
