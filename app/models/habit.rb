# frozen_string_literal: true

class Habit < ApplicationRecord
  belongs_to :habit_type
  belongs_to :user
  has_many :daily_habits, dependent: :destroy

  before_create :set_disabled_to_false
  after_create :create_daily_habits_for_user

  private

  def create_daily_habits_for_user
    daily_habits.create!(user:, done: false)
  end

  def set_disabled_to_false
    self.disabled = false
  end
end
