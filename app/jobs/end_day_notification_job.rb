class EndDayNotificationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.all.each do |user|
      next unless user.telegram_id && user.end_of_day?

      send_messages(user)
    end
  end

  private

  def send_messages(user)
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: daily_habits_text(user.all_daily_habits_for_today))
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: 'Como te sentiste hoy?',
                              reply_markup: daily_rating_message)
  end

  def daily_habits_text(daily_habits)
    if daily_habits.empty?
      return "Llegamos al final del dia, hoy fue un dia para fluir! \xF0\x9F\x92\xA4 \xF0\x9F\x92\xA4 "
    end

    'Estamos llegando al final del dia! Este es el resumen de hoy: '\
    "\n \n#{daily_habits.map { |daily_habit| daily_habit_done_emoji(daily_habit) + daily_habit.name }.join("\n")}"\
    "\n "\
  end

  def daily_habit_done_emoji(daily_habit)
    daily_habit.done ? "\xE2\x9C\x85 " : "\xE2\x97\xBB "
  end

  def daily_rating_message # rubocop:disable Metrics/MethodLength
    {
      inline_keyboard: [
        [
          { text: " 1. \xF0\x9F\x98\xA4 ", callback_data: "create_dr:1##{Date.today.strftime('%d/%m/%Y')}" },
          { text: " 2. \xF0\x9F\x98\x94 ", callback_data: "create_dr:2##{Date.today.strftime('%d/%m/%Y')}" },
          { text: " 3. \xF0\x9F\x98\x8A ", callback_data: "create_dr:3##{Date.today.strftime('%d/%m/%Y')}" },
          { text: " 4. \xF0\x9F\x98\x84 ", callback_data: "create_dr:4##{Date.today.strftime('%d/%m/%Y')}" },
          { text: " 5. \xF0\x9F\x98\x8D	 ", callback_data: "create_dr:5##{Date.today.strftime('%d/%m/%Y')}" }
        ]
      ]
    }
  end
end
