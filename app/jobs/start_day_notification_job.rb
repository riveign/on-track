class StartDayNotificationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    User.all.each do |user|
      next unless user.telegram_id && user.start_of_day

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
    return "Hoy se puede descansar! \xF0\x9F\x92\xA4 \xF0\x9F\x92\xA4 " if habits.empty?

    'Un nuevo dia, Una nueva oportunidad de estar On Track! Estas son las cosas para hacer: '\
    "\n \n \xE2\x97\xBB	 #{habits.map(&:name).join("\n \xE2\x97\xBB	")}"\
    "\n "\
    "\n \xF0\x9F\x8F\x84	\xF0\x9F\x8F\x84 \xF0\x9F\x8F\x84	"
  end

  def reminders_texts(reminders)
    return 'No hay recordatorios para hoy!' if reminders.empty?

    'Estos son los recordatorios para hoy: '\
    "\n \n \xE2\x97\xBB	 #{reminders.map(&:title).join("\n \xE2\x97\xBB	 ")}"\
    "\n "\
    "\n \xF0\x9F\x95\x90	\xF0\x9F\x95\x90 \xF0\x9F\x95\x90 "
  end
end
