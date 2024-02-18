class Reminder < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :due_date, presence: true
  validates :user, presence: true
  validates :done, inclusion: { in: [true, false] }
  validate :due_date_cannot_be_in_the_past

  scope :upcoming, lambda { |days = 15|
                     where('due_date >= ?', Time.zone.now).where('due_date <= ?', Time.zone.now + days.days).where(done: false)
                   }
  scope :due_today, lambda {
                      where(due_date: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).where(done: false)
                    }

  after_create :schedule_notification

  def days_until_due
    (due_date.to_date - Date.today).to_i
  end

  def telegram_notification
    if days_until_due >= 1
      "No te olvides de #{title} para dentro de #{days_until_due} dias!"
    else
      "No te olvides de #{title} para hoy!"
    end
  end

  private

  def schedule_notification
    ReminderNotificationJob.set(wait_until: due_date - 2.hours).perform_later(self)
  end

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, "can't be in the past") if due_date.present? && due_date < Time.zone.now
  end
end
