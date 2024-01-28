# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :habits, dependent: :destroy
  has_many :daily_habits, dependent: :destroy

  def daily_habits_for_today
    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    daily_habits.where(created_at: today_range, done: false)
  end
end
