class AddDayStartEndToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :day_start, :integer, default: 8
    add_column :users, :day_end, :integer, default: 21
  end
end
