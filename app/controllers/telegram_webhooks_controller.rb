class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  def start!(*_words)
    if (user = User.find_by(telegram_id: from['id']))
      respond_with :message, text: "Bienvenido, #{user.email}"
    else
      respond_with :message,
                   text: 'Bienvendio a On Track!'
      respond_with :message, text: 'Si ya tienes una cuenta, puedes vincularla con tu telegram en /register <email>'
      respond_with :message, text: "De otro modo crea una cuenta en #{ENV['DEVELOPMENT_HOSTS']}/users/sign_up"
    end
  end

  def register!(word = nil, *_other_words)
    if (user = User.find_by(telegram_id: from['id'])) || (word.present? && (user = User.find_by(email: word)))
      user.update!(telegram_id: from['id'])
      respond_with :message, text: "Bienvenido, #{user.email}"
    else
      respond_with :message,
                   text: 'Si ya tienes una cuenta, puedes vincularla con tu telegram en /register <email>'
      respond_with :message, text: "De otro modo crea una cuenta en #{ENV['DEVELOPMENT_HOSTS']}/users/sign_up"
    end
  end

  def stop!(*_words)
    if user = User.find_by(telegram_id: from['id'])
      user.update!(telegram_id: nil)
      respond_with :message, text: "Adios, #{user.email}, no te enviaremos mas recordatorios"
    else
      respond_with :message, text: 'No estas registrado'
    end
  end

  def help!(*)
    respond_with :message, text: 'Utiliza /start para comenzar'
    respond_with :message, text: 'Utiliza /register <email> para vincular tu cuenta'
    respond_with :message, text: 'Utiliza /stop para descatviar los recordatorios'
  end

  def callback_query(data)
    if data == 'no'
      answer_callback_query 'Todavia Hay Tiempo!', show_alert: true
    else
      DailyHabit.find(data).update!(done: true)
      answer_callback_query 'Listo!', show_alert: true
    end
  end
end
