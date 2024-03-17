# Description: This controller is responsible for handling the Telegram bot's webhooks.
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::CallbackQueryContext
  include Telegram::Bot::UpdatesController::MessageContext
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

  def review_day!(_word = nil, *_other_words)
    return unless (user = User.find_by(telegram_id: from['id']))

    respond_with :message, text: t('telegram.review_day.start_review')
    daily_habit_ids = user.daily_habits_for_today.map(&:id)
    if daily_habit_ids.any?
      daily_habit = DailyHabit.find(daily_habit_ids.sample)
      daily_habit_ids.delete(daily_habit.id)
      respond_with :message, text: t('telegram.daily_habit.confirmation', daily_habit: daily_habit.habit.name),
                             reply_markup: {
                               inline_keyboard: [
                                 [
                                   { text: emoji(:green_check),
                                     callback_data: "update_dh_review:#{daily_habit.id}%#{daily_habit_ids}" },
                                   { text: emoji(:red_cross), callback_data: "update_dh_review:no%#{daily_habit_ids}" }
                                 ]
                               ]
                             }
    else
      respond_with :message, text: t('telegram.review_day.no_daily_habits')
    end
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

  def update_dh_review_callback_query(value = nil, *)
    value, daily_habit_ids = value.split('%')
    daily_habit_ids = daily_habit_ids[1..-2].split(',').map(&:to_i)
    if value == 'no'
      edit_message('text',
                   { text: "#{t('telegram.daily_habit.motivation')}	#{emoji(:strength, 3)} " })
    elsif DailyHabit.find(value).update!(done: true)
      edit_message('text',
                   { text: "#{t('telegram.daily_habit.congratulations')}  #{emoji(:celebration, 3)} " })
    end
    if daily_habit_ids.any?
      daily_habit = DailyHabit.find(daily_habit_ids.sample)
      daily_habit_ids.delete(daily_habit.id)
      respond_with :message, text: t('telegram.daily_habit.confirmation', daily_habit: daily_habit.habit.name),
                             reply_markup: {
                               inline_keyboard: [
                                 [
                                   { text: emoji(:green_check),
                                     callback_data: "update_dh_review:#{daily_habit.id}%#{daily_habit_ids}" },
                                   { text: emoji(:red_cross), callback_data: "update_dh_review:no%#{daily_habit_ids}" }
                                 ]
                               ]
                             }
    else
      respond_with :message, text: t('telegram.review_day.no_daily_habits')
    end
  end
end
