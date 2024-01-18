# frozen_string_literal: true

class HabitType < ApplicationRecord
  has_many :habits
end
