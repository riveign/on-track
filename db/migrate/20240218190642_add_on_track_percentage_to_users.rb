class AddOnTrackPercentageToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :on_track_percentage, :decimal, precision: 3, scale: 2, default: 1.0
  end
end
