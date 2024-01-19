class CreateDailyHabits < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_habits do |t|
      t.references :habit, null: false, foreign_key: true
      t.boolean :done

      t.timestamps
    end
  end
end
