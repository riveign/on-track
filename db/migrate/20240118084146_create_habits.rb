# frozen_string_literal: true

class CreateHabits < ActiveRecord::Migration[7.1]
  def change
    create_table :habits do |t|
      t.string :name
      t.text :description
      t.references :habit_type, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
