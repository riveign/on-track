class ChangeIntegerLimitInUserTelegramId < ActiveRecord::Migration[7.1]
  def up
    change_column :users, :telegram_id, :bigint
  end

  def down
    change_column :users, :telegram_id, :integer
  end
end
