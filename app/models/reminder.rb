class Reminder < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :due_date, presence: true
  validates :user, presence: true
  validate :due_date_cannot_be_in_the_past

  scope :upcoming, -> { where('due_date >= ?', Time.zone.now).where(done: false) }

  private

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, "can't be in the past") if due_date.present? && due_date < Time.zone.now
  end
end
