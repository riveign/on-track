class DailyHabitConfirmationJob < ApplicationJob
  queue_as :default

  def perform # rubocop:disable Metrics/AbcSize
    User.all.each do |user|
      next unless user.telegram_id && user.daily_habits_for_today.any? && user.active_hours?

      user.daily_habits_for_today.sample(1).each do |daily_habit|
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: text(daily_habit),
                                  reply_markup: reply_markup(daily_habit))
      rescue StandardError => e
        Rails.logger.error "Failed to send message via Telegram: #{e.message}"
      end
    end
  end

  private

  def text(daily_habit)
    I18n.t('telegram.daily_habit.confirmation', daily_habit: daily_habit.habit.name)
  end

  def reply_markup(daily_habit)
    {
      inline_keyboard: [
        [
          { text: emoji(:green_check), callback_data: "update_dh:#{daily_habit.id}" },
          { text: emoji(:red_cross), callback_data: 'update_dh:no' }
        ]
      ]
    }
  end
end
