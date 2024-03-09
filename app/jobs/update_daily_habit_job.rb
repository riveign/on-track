class UpdateDailyHabitJob < ApplicationJob
  queue_as :default

  def perform(daily_habit:, user:)
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: I18n.t('telegram.daily_habit.done',
                                           title: daily_habit.habit.name) + emoji(:green_check))
  rescue StandardError => e
    Rails.logger.error "Failed to send message via Telegram: #{e.message}"
  end
end
