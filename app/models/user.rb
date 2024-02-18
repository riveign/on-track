# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :habits, dependent: :destroy
  has_many :daily_habits, dependent: :destroy
  has_many :reminders, dependent: :destroy

  before_create :set_default_values

  def daily_habits_for_today
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    daily_habits.where(created_at: today_range, done: false)
  end

  private

  def set_default_values
    self.on_track_percentage = 1
  end
end
