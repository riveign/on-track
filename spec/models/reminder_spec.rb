require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe 'validations' do
    it 'should validate that date cannot be in the past' do
      reminder = Reminder.new(due_date: Date.yesterday)
      reminder.valid?
      expect(reminder.errors[:due_date]).to include("can't be in the past")
    end
  end
end
