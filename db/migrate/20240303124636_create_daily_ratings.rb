class CreateDailyRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :daily_ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.date :rated_on, null: false

      t.timestamps
    end
    add_index :daily_ratings, %i[user_id rated_on], unique: true
  end
end
