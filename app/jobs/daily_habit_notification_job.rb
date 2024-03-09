class DailyHabitNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      next unless user_can_recieve_message(user)

      user.daily_habits_for_today.sample(1).each do |daily_habit|
        Telegram.bot.send_message(chat_id: user.telegram_id, text: text(daily_habit))
      rescue StandardError => e
        Rails.logger.error "Failed to send message via Telegram: #{e.message}"
      end
    end
  end

  private

  def user_can_recieve_message(user)
    user.telegram_id && user.daily_habits_for_today.any? && user.active_hours?
  end

  def text(daily_habit)
    I18n.t('telegram.daily_habit.reminder', daily_habit: daily_habit.habit.name) + emoji(:strength)
  end
end
