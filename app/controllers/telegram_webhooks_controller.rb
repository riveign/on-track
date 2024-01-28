class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  def start!(_word = nil, *_other_words)
    respond_with :message, text: 'Bienvenido'
  end

  def help!(*)
    respond_with :message, text: 'Esta es la ayuda'
  end
end
