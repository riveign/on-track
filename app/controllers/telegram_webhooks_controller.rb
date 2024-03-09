class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::CallbackQueryContext
  include EmojisHelper

  def start!(*_words)
    if (user = User.find_by(telegram_id: from['id']))
      respond_with :message, text: "#{t('telegram.start_email', email: user.email)} #{emoji(:happy_face)} "
    else
      respond_with :message,
                   text: t('telegram.start_welcome_1')
      respond_with :message, text: t('telegram.start_welcome_2')
      respond_with :message, text: t('telegram.start_welcome_3', host: ENV['DEVELOPMENT_HOSTS'])
    end
  end

  def register!(word = nil, *_other_words)
    if (user = User.find_by(telegram_id: from['id'])) || (word.present? && (user = User.find_by(email: word)))
      user.update!(telegram_id: from['id'])
      respond_with :message, text: t('telegram.start_email', email: user.email)
    else
      respond_with :message,
                   text: t('telegram.start_welcome_2')
      respond_with :message, text: t('telegram.start_welcome_3', host: ENV['DEVELOPMENT_HOSTS'])
    end
  end

  def stop!(*_words)
    if (user = User.find_by(telegram_id: from['id']))
      user.update!(telegram_id: nil)
      respond_with :message, text: t('telegram.stop.goodbye', email: user.email)
    else
      respond_with :message, text: t('telegram.stop.not_registered')
    end
  end

  def help!(*)
    respond_with :message, text: t('telegram.help.start')
    respond_with :message, text: t('telegram.help.register')
    respond_with :message, text: t('telegram.help.stop')
  end

  def update_dh_callback_query(value = nil, *)
    if value == 'no'
      edit_message('text',
                   { text: "#{t('telegram.daily_habit.motivation')}	#{emoji(:strength, 3)} " })
    elsif DailyHabit.find(value).update!(done: true)
      edit_message('text',
                   { text: "#{t('telegram.daily_habit.congratulations')}  #{emoji(:celebration, 3)} " })
    end
  end

  def update_r_callback_query(value = nil, *)
    if value == 'no'
      edit_message('text',
                   { text: "#{t('telegram.reminders.motivation')} #{emoji(:strength, 3)} " })
    elsif Reminder.find(value).update!(done: true)
      edit_message('text',
                   { text: "#{t('telegram.reminders.congratulations')}  #{emoji(:celebration, 3)} " })
    end
  end

  def create_dr_callback_query(value = nil, *)
    result, date = value.split('#')
    return unless (1..5).include?(result.to_i) && Date.parse(date)

    return unless (user = User.find_by(telegram_id: from['id']))

    DailyRating.create!(user:, rating: result, rated_on: date)
    edit_message('text',
                 { text: "#{t('telegram.daily_rating.thanks')} #{emoji(:happy_face, 3)}" })
  end
end
