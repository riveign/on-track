class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  def start!(*)
    if User.find_by(telegram_id: from['id'])
      respond_with :message, text: 'Bienvenido'
    else
      respond_with :message, text: 'No eres bienvenido'
    end
  end

  def help!(*)
    respond_with :message, text: 'Esta es la ayuda'
  end
end
