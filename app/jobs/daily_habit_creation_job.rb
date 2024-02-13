class DailyHabitCreationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    users = User.all
    users.each do |user|
      DailyHabitService.new(user).create_daily_habits
      Rails.logger.info "Daily habits created for user #{user.id}"
      if user.telegram_id
        Telegram.bot.send_message(chat_id: user.telegram_id,
                                  text: text(user.habits.active))
      end
    end
  end

  private

  def text(habits)
    return 'Hoy se puede descansar!' if habits.empty?

    'Un nuevo dia, Una nueva oportunidad de estar On Track! Estas son las cosas para hacer: '\
    "\n -  #{habits.map(&:name).join("\n")}"
  end
end
