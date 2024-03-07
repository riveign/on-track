class UpdateDailyHabitJob < ApplicationJob
  queue_as :default

  def perform(daily_habit:, user:)
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: "Eso! #{daily_habit.habit.name} \xE2\x9C\x85")
  rescue StandardError => e
    Rails.logger.error "Failed to send message via Telegram: #{e.message}"
  end
end
