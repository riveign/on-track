module EmojisHelper
  EMOJI_MAP = {
    happy_face: " \xF0\x9F\x98\x81 ",
    strength: " \xF0\x9F\x92\xAA ",
    celebration: " \xF0\x9F\x8E\x8A "
  }.freeze

  def emoji(name, repetition = 1)
    emoji_character = EMOJI_MAP[name]
    emoji_character * repetition if emoji_character
  end
end
