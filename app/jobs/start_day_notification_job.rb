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
  rescue StandardError => e
    Rails.logger.error "Failed to send message via Telegram: #{e.message}"
  end

  def habits_texts(habits)
    return I18n.t('telegram.start_day.empty_habits') + emoji(:sleeping) if habits.empty?

    I18n.t('telegram.start_day.introduction_habits') +
      "\n \n#{habits.map { |habit| "#{emoji(:not_done)}	#{habit.name}" }.join("\n")}"\
      "\n "\
      "\n "	+ emoji(:surfer, 3)
  end

  def reminders_texts(reminders)
    return I18n.t('telegram.start_day.empty_reminders') if reminders.empty?

    I18n.t('telegram.start_day.introduction_reminders') +
      "\n \n#{reminders.map { |reminder| "#{emoji(:not_done)}	#{reminder.title}" }.join("\n")}"\
      "\n "\
      "\n " + emoji(:clock, 3)
  end
end
