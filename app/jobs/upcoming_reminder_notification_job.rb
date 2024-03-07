class UpcomingReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform # rubocop:disable Metrics/AbcSize
    User.all.each do |user|
      next unless user.telegram_id && user.reminders.upcoming.any? && user.active_hours?

      user.reminders.upcoming.sample(1).each do |reminder|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: reminder.telegram_notification)
      rescue StandardError => e
        Rails.logger.error "Failed to send message via Telegram: #{e.message}"
      end
    end
  end
end
