require 'rails_helper'

RSpec.describe DailyRating, type: :model do # rubocop:disable Metrics/BlockLength
  describe 'validations' do
    it 'should validate that rating is present' do
      daily_rating = DailyRating.new(rating: nil)
      daily_rating.valid?
      expect(daily_rating.errors[:rating]).to include("can't be blank")
    end

    it 'should validate that rating is between 1 and 5' do
      daily_rating = DailyRating.new(rating: 6)
      daily_rating.valid?
      expect(daily_rating.errors[:rating]).to include('is not included in the list')
    end

    it 'should validate that rated_on is present' do
      daily_rating = DailyRating.new(rated_on: nil)
      daily_rating.valid?
      expect(daily_rating.errors[:rated_on]).to include("can't be blank")
    end

    it 'should validate that user_id is unique for a given rated_on' do
      user = create(:user)
      create(:daily_rating, user:, rated_on: Date.today)
      daily_rating = DailyRating.new(user:, rated_on: Date.today)
      daily_rating.valid?
      expect(daily_rating.errors[:user_id]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'should belong to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
