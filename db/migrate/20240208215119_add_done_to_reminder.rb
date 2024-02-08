class AddDoneToReminder < ActiveRecord::Migration[7.1]
  def change
    add_column :reminders, :done, :boolean, default: false
  end
end
