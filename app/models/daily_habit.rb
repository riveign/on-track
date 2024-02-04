class DailyHabit < ApplicationRecord
  belongs_to :habit
  belongs_to :user

  validates :habit, presence: true
  validates :user, presence: true
  validate :habit_not_already_logged_today

  def habit_not_already_logged_today
    # Check if a record with the same habit_id exists for today
    existing_record = DailyHabit.where(habit_id:,
                                       created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).exists?

    errors.add(:habit_id, 'has already been logged for today') if existing_record
  end
end
