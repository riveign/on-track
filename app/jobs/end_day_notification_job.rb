class EndDayNotificationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.all.each do |user|
      next unless user.telegram_id

      send_messages(user)
    end
  end

  private

  def send_messages(user)
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: daily_habits_text(user.all_daily_habits_for_today))
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: I18n.t('telegram.daily_rating.question'),
                              reply_markup: daily_rating_message)
  rescue StandardError => e
    Rails.logger.error "Failed to send message via Telegram: #{e.message}"
  end

  def daily_habits_text(daily_habits)
    return I18n.t('telegram.end_day.empty') + emoji(:sleeping) if daily_habits.empty?

    I18n.t('telegram.end_day.introduction') +
      "\n \n#{daily_habits.map { |daily_habit| daily_habit_done_emoji(daily_habit) + daily_habit.name }.join("\n")}" \
      "\n "
  end

  def daily_habit_done_emoji(daily_habit)
    daily_habit.done ? emoji(:done) : emoji(:not_done)
  end

  def daily_rating_message # rubocop:disable Metrics/MethodLength
    {
      inline_keyboard: [
        [
          { text: emoji(:rating1), callback_data: "create_dr:1##{Date.today.strftime('%d/%m/%Y')}" },
          { text: emoji(:rating2), callback_data: "create_dr:2##{Date.today.strftime('%d/%m/%Y')}" },
          { text: emoji(:rating3), callback_data: "create_dr:3##{Date.today.strftime('%d/%m/%Y')}" },
          { text: emoji(:rating4), callback_data: "create_dr:4##{Date.today.strftime('%d/%m/%Y')}" },
          { text: emoji(:rating5), callback_data: "create_dr:5##{Date.today.strftime('%d/%m/%Y')}" }
        ]
      ]
    }
  end
end
