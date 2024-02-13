require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe 'validations' do
    it 'should validate that date cannot be in the past' do
      reminder = Reminder.new(due_date: Date.yesterday)
      reminder.valid?
      expect(reminder.errors[:due_date]).to include("can't be in the past")
    end
  end

  describe '#days_until_due' do
    it 'should return the number of days until the due date' do
      reminder = Reminder.new(due_date: Date.today + 3)
      expect(reminder.days_until_due).to eq(3)
    end

    it 'should return a negative number if the due date is in the past' do
      reminder = Reminder.new(due_date: Date.yesterday)
      expect(reminder.days_until_due).to be < 0
    end
  end

  describe '#telegram_notification' do
    it 'should return the correct message when days_until_due is greater than or equal to 1' do
      reminder = Reminder.new(title: 'Some Reminder', due_date: Date.today + 3)
      expect(reminder.telegram_notification).to eq('No te olvides de Some Reminder para dentro de 3 dias!')
    end

    it 'should return the correct message when days_until_due is less than 1' do
      reminder = Reminder.new(title: 'Some Reminder', due_date: Date.today)
      expect(reminder.telegram_notification).to eq('No te olvides de Some Reminder para hoy!')
    end
  end
end
