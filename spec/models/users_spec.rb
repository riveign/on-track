require 'rails_helper'

RSpec.describe User, type: :model do # rubocop:disable Metrics/BlockLength
  describe '#set_default_values' do
    let(:user) { create(:user) }

    it 'sets the on_track_percentage to 1' do
      expect(user.on_track_percentage).to eq(1)
    end

    it 'sets the time_zone to UTC' do
      expect(user.time_zone).to eq('UTC')
    end

    it 'sets the day_start to start day' do
      expect(user.day_start).to eq(User::START_OF_DAY)
    end

    it 'sets the day_end to 22' do
      expect(user.day_end).to eq(User::END_OF_DAY)
    end
  end

  describe 'active hours' do
    let(:user) { create(:user) }

    before do
      time = Time.find_zone!(user.time_zone).parse('7:21 AM')
      travel_to time
    end

    after { travel_back }

    it 'returns true between start and end of day' do
      time = Time.find_zone!(user.time_zone).parse('9:21 AM')
      travel_to time
      expect(user.active_hours?).to be_truthy
    end

    it 'returns false outside of start and end of day' do
      expect(user.active_hours?).to be_falsey
    end
  end

  describe 'midnight?' do
    let(:user) { create(:user) }

    before do
      time = Time.find_zone!(user.time_zone).parse('7:21 AM')
      travel_to time
    end

    after { travel_back }

    it 'returns false before midnight' do
      expect(user.midnight?).to be_falsey
    end

    it 'returns true at midnight' do
      time = Time.find_zone!(user.time_zone).parse('12:00 AM')
      travel_to time
      expect(user.midnight?).to be_truthy
    end
  end
end
