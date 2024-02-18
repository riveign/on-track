module HabitsHelper
  def on_track?(accomplishment_percentage, user)
    if accomplishment_percentage >= user.on_track_percentage * 100
      'On track'
    else
      'Off track'
    end
  end
end
