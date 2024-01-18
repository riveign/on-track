# frozen_string_literal: true

class Habit < ApplicationRecord
  belongs_to :habit_type
  belongs_to :user
end
