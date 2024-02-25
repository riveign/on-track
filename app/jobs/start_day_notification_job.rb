class StartDayNotificationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.all.each do |user|
      next unless user.telegram_id && user.start_of_day?

      send_messages(user)
    end
  end

  private

  def send_messages(user)
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: habits_texts(user.habits.active))
    Telegram.bot.send_message(chat_id: user.telegram_id,
                              text: reminders_texts(user.reminders.due_today))
  end

  def habits_texts(habits)
    return 'Hoy se puede descansar!' if habits.empty?

    'Un nuevo dia, Una nueva oportunidad de estar On Track! Estas son las cosas para hacer: '\
    "\n - #{habits.map(&:name).join("\n -")}"
  end

  def reminders_texts(reminders)
    return 'No hay recordatorios para hoy!' if reminders.empty?

    'Estos son los recordatorios para hoy: '\
    "\n - #{reminders.map(&:name).join("\n -")}"
  end
end
