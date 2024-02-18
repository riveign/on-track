require 'rails_helper'

RSpec.describe HabitsHelper, type: :helper do
  describe '#on_track?' do
    let(:user) { create(:user) }

    context 'when accomplishment percentage is greater than or equal to on track percentage' do
      it 'returns "On track"' do
        accomplishment_percentage = user.on_track_percentage * 100
        expect(helper.on_track?(accomplishment_percentage, user)).to eq('On track')
      end
    end

    context 'when accomplishment percentage is less than on track percentage' do
      it 'returns "Off track"' do
        accomplishment_percentage = user.on_track_percentage * 100 - 1
        expect(helper.on_track?(accomplishment_percentage, user)).to eq('Off track')
      end
    end
  end
end
