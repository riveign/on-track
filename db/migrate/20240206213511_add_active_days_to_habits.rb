class AddActiveDaysToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :active_days, :string, array: true, default: []
  end
end
