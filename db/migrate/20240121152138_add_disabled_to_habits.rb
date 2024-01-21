class AddDisabledToHabits < ActiveRecord::Migration[7.1]
  def change
    add_column :habits, :disabled, :boolean
  end
end
