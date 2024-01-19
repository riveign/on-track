class AddUserToDailyHabits < ActiveRecord::Migration[7.1]
  def change
    add_reference :daily_habits, :user, null: false, foreign_key: true
  end
end
