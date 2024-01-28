class DailyHabitCreationJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    users = User.all
    users.each do |user|
      DailyHabitService.new(user).create_daily_habits
      Rails.logger.info "Daily habits created for user #{user.id}"
      Telegram.bot.send_message(chat_id: user.telegram_id,
                                text: 'Brand New day lets get back on track!')
    end
  end
end
