# app/services/daily_review_service.rb
class DailyReviewService
  def self.perform(daily_habit_ids)
    new(daily_habit_ids).perform
  end

  def initialize(daily_habit_ids)
    @daily_habit_ids = daily_habit_ids
  end

  def perform
    if @daily_habit_ids.any?
      daily_habit = DailyHabit.find(@daily_habit_ids.sample)
      @daily_habit_ids.delete(daily_habit.id)
      {
        text: I18n.t('telegram.daily_habit.confirmation', daily_habit: daily_habit.habit.name),
        reply_markup: inline_keyboard_for(daily_habit, @daily_habit_ids)
      }
    else
      { text: I18n.t('telegram.review_day.no_daily_habits') }
    end
  end

  private

  def inline_keyboard_for(daily_habit, remaining_ids)
    {
      inline_keyboard: [
        [
          { text: '✅', callback_data: "update_dh_review:#{daily_habit.id}%#{remaining_ids}" },
          { text: '❌', callback_data: "update_dh_review:no%#{remaining_ids}" }
        ]
      ]
    }
  end
end
