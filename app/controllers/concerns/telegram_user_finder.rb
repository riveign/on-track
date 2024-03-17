# app/controllers/concerns/user_finder.rb
module TelegramUserFinder
  extend ActiveSupport::Concern

  included do
    before_action :find_user_by_telegram_id, except: %i[help!]
  end

  private

  def find_user_by_telegram_id
    telegram_id = from['id'] # Accessing the Telegram ID from the incoming webhook payload
    @user = User.find_by(telegram_id:)
  end
end
