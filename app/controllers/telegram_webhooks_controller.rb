# Description: This controller is responsible for handling the Telegram bot's webhooks.
class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::CallbackQueryContext
  include EmojisHelper
  include TelegramUserFinder

  def start!(*)
    text = if @user
             "#{t('telegram.start_email', email: @user.email)} #{emoji(:happy_face)}"
           else
             welcome_messages.join("\n")
           end
    respond_with :message, text:
  end

  def register!(word = nil, *_other_words)
    if @user || (word.present? && (@user = User.find_by(email: word)))
      @user.update!(telegram_id: from['id'])
      respond_with :message, text: t('telegram.start_email', email: @user.email)
    else
      respond_with :message,
                   text: t('telegram.start_welcome_2')
      respond_with :message, text: t('telegram.start_welcome_3', host: ENV['DEVELOPMENT_HOSTS'])
    end
  end

  def stop!(*_words)
    if @user
      @user.update!(telegram_id: nil)
      respond_with :message, text: t('telegram.stop.goodbye', email: @user.email)
    else
      respond_with :message, text: t('telegram.stop.not_registered')
    end
  end

  def help!(*)
    help_messages = [
      t('telegram.help.start'),
      t('telegram.help.register'),
      t('telegram.help.stop'),
      t('telegram.help.review_day')
    ]
    respond_with_multiple_messages(help_messages)
  end

  def review_day!(_word = nil, *_other_words)
    return unless @user

    respond_with :message, text: t('telegram.review_day.start_review')
    review_result = DailyReviewService.perform(@user.daily_habits_for_today.map(&:id))
    respond_with :message, text: review_result[:text], reply_markup: review_result[:reply_markup]
  end

  def update_dh_callback_query(value = nil, *)
    edit_message('text', DailyHabitUpdateService.perform(value))
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
    edit_message('text', DailyHabitUpdateService.perform(value))
    review_result = DailyReviewService.perform(daily_habit_ids[1..-2].split(',').map(&:to_i))
    respond_with :message, text: review_result[:text], reply_markup: review_result[:reply_markup]
  end

  private

  def welcome_messages
    [
      t('telegram.start_welcome_1'),
      t('telegram.start_welcome_2'),
      t('telegram.start_welcome_3', host: ENV['DEVELOPMENT_HOSTS'])
    ]
  end

  def respond_with_multiple_messages(messages)
    messages.each { |message| respond_with :message, text: message }
  end
end
