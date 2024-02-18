require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#set_default_values' do
    let(:user) { create(:user) }

    it 'sets the on_track_percentage to 1' do
      expect(user.on_track_percentage).to eq(1)
    end
  end
end
