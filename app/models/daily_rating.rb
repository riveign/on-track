class DailyRating < ApplicationRecord
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :rated_on, presence: true
  validates :user_id, uniqueness: { scope: :rated_on }
end
