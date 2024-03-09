module EmojisHelper
  EMOJI_MAP = {
    happy_face: " \xF0\x9F\x98\x81 ",
    strength: " \xF0\x9F\x92\xAA ",
    celebration: " \xF0\x9F\x8E\x8A ",
    green_check: " \xE2\x9C\x85 ",
    red_cross: " \xE2\x9D\x8C ",
    sleeping: " \xF0\x9F\x92\xA4 ",
    done: " \xE2\x9C\x85 ",
    not_done: " \xE2\x97\xBB ",
    rating1: " \xF0\x9F\x98\xA4 ",
    rating2: " \xF0\x9F\x98\x94 ",
    rating3: " \xF0\x9F\x98\x8A ",
    rating4: " \xF0\x9F\x98\x84 ",
    rating5: " \xF0\x9F\x98\x8D ",
    clock: " \xE2\x8F\xB0 ",
    warning: " \xE2\x9A\xA0 ",
    surfer: " \xF0\x9F\x8F\x84 "
  }.freeze

  def emoji(name, repetition = 1)
    emoji_character = EMOJI_MAP[name]
    emoji_character * repetition if emoji_character
  end
end
