# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :habits, dependent: :destroy
  has_many :daily_habits, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_many :daily_ratings, dependent: :destroy

  before_create :set_default_values

  validates :day_start, :day_end,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 23, only_integer: true }

  validate :start_must_be_before_end

  START_OF_DAY = 8
  END_OF_DAY = 22

  def daily_habits_for_today
    Time.use_zone(time_zone) do
      today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      daily_habits.where(created_at: today_range, done: false)
    end
  end

  def all_daily_habits_for_today
    Time.use_zone(time_zone) do
      today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      daily_habits.where(created_at: today_range)
    end
  end

  def active_hours?
    Time.use_zone(time_zone) do
      return Time.zone.now.hour.between?(day_start, day_end)
    end
  end

  def midnight?
    Time.use_zone(time_zone) do
      return Time.zone.now.hour.zero?
    end
  end

  def start_of_day?
    Time.use_zone(time_zone) do
      return Time.zone.now.hour.eql?(day_start)
    end
  end

  def end_of_day?
    Time.use_zone(time_zone) do
      return Time.zone.now.hour.eql?(day_end)
    end
  end

  def ratings_for_last_days(days = 30)
    end_date = Date.today
    start_date = end_date - days.days
    ratings = daily_ratings.where(rated_on: start_date..end_date).pluck(:rated_on, :rating).to_h

    (start_date..end_date).map { |date| [date, ratings[date] || 0] }
  end

  private

  def set_default_values
    self.day_start = START_OF_DAY
    self.day_end = END_OF_DAY
    self.on_track_percentage = 1
    self.time_zone = 'UTC'
  end

  def start_must_be_before_end
    return if day_start.blank? || day_end.blank?

    return unless day_start >= day_end

    errors.add(:day_start, 'must be before the end of the day')
  end
end
