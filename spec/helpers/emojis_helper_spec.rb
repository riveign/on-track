require 'rails_helper'

RSpec.describe EmojisHelper, type: :helper do
  describe '#emoji' do
    it 'returns the emoji character for a given name' do
      expect(helper.emoji(:happy_face)).to eq(" \xF0\x9F\x98\x81 ")
    end

    it 'returns multiple repetitions of the emoji character' do
      expect(helper.emoji(:strength, 3)).to eq(" \xF0\x9F\x92\xAA  \xF0\x9F\x92\xAA  \xF0\x9F\x92\xAA ")
    end

    it 'returns nil if the emoji name is not found' do
      expect(helper.emoji(:unknown_emoji)).to be_nil
    end
  end
end
