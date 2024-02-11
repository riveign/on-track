class DailyHabit < ApplicationRecord
  belongs_to :habit
  belongs_to :user

  validates :habit, presence: true
  validates :user, presence: true
  validate :habit_not_already_logged_today
  validate :habit_is_active_today

  scope :not_done, -> { where(done: false) }

  private

  def habit_is_active_today
    date = created_at ? created_at.to_date : Date.current
    return if habit.active_days.include?((date.wday.zero? ? 7 : date.wday).to_s)

    errors.add(:habit_id, 'is not active today')
  end

  def habit_not_already_logged_today
    time_frame = created_at ? created_at.beginning_of_day..created_at.end_of_day : Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    is_logged_today = DailyHabit.where(user_id:, habit_id:)
                                .where('created_at >= ? AND created_at <= ?', time_frame.begin, time_frame.end)
                                .where.not(id:)
                                .exists?
    errors.add(:habit_id, 'has already been logged for today') if is_logged_today
  end
end
