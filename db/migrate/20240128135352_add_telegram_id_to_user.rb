class AddTelegramIdToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :telegram_id, :integer
  end
end
