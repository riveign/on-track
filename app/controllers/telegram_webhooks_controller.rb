class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  def start!(*_words)
    if (user = User.find_by(telegram_id: from['id']))
      respond_with :message, text: "Bienvenido, #{user.email}"
    else
      respond_with :message, text: 'No tienes una cuenta, por favor registrate con /register'
    end
  end

  def register!(word = nil, *_other_words)
    if (user = User.find_by(telegram_id: from['id'])) || (word.present? && (user = User.find_by(email: word)))
      user.update!(telegram_id: from['id'])
      respond_with :message, text: "Bienvenido, #{user.email}"
    else
      respond_with :message,
                   text: "Ingresa un correo valido o puedes registrarte en #{ENV['DEVELOPMENT_HOSTS']}/users/sign_up"
    end
  end

  def help!(*)
    respond_with :message, text: 'Esta es la ayuda'
  end
end
