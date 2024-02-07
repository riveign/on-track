# frozen_string_literal: true

class Habit < ApplicationRecord
  belongs_to :habit_type
  belongs_to :user
  has_many :daily_habits, dependent: :destroy

  before_create :set_disabled_to_false
  after_create :create_daily_habits_for_user

  scope :active, -> { where('active_days @> ARRAY[?]::varchar[]', [Date.current.wday.to_s]) }

  # Method to calculate the streak
  def streak
    daily_habits.where(done: true).where('created_at >= ? AND created_at <= ?', streak_start_date,
                                         Date.current.end_of_day).count
  end

  private

  def streak_start_date
    last_incomplete_day = daily_habits.where(done: false)
                                      .where('created_at < ?', Date.current.beginning_of_day)
                                      .order(created_at: :desc)
                                      .first
    last_incomplete_day ? last_incomplete_day.created_at.to_date + 1.day : created_at.to_date
  end

  def create_daily_habits_for_user
    daily_habits.create!(user:, done: false) if active_days.include?(Date.current.wday.to_s)
  end

  def set_disabled_to_false
    self.disabled = false
  end
end
