class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::CallbackQueryContext
  def start!(*_words)
    if (user = User.find_by(telegram_id: from['id']))
      respond_with :message, text: "Bienvenido, #{user.email} \xF0\x9F\x98\x81 "
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
    if (user = User.find_by(telegram_id: from['id']))
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

  def update_dh_callback_query(value = nil, *)
    if value == 'no'
      edit_message('text',
                   { text: "Todavia tenes tiempo hoy, no pierdas la racha! \xF0\x9F\x92\xAA	 \xF0\x9F\x92\xAA	 \xF0\x9F\x92\xAA	" })
    elsif DailyHabit.find(value).update!(done: true)
      edit_message('text',
                   { text: "Felicitaciones, una cosa menos en la lista de hoy! \xF0\x9F\x8E\x8A \xF0\x9F\x8E\x8A \xF0\x9F\x8E\x8A" })
    end
  end

  def update_r_callback_query(value = nil, *)
    if value == 'no'
      edit_message('text',
                   { text: "Vamos que se puede! \xF0\x9F\x92\xAA	 \xF0\x9F\x92\xAA	 \xF0\x9F\x92\xAA	" })
    elsif Reminder.find(value).update!(done: true)
      edit_message('text',
                   { text: "Felicitaciones, una cosa menos en la lista de hoy! \xF0\x9F\x8E\x8A \xF0\x9F\x8E\x8A \xF0\x9F\x8E\x8A" })
    end
  end

  def create_dr_callback_query(value = nil, *)
    result, date = value.split('#')
    return unless (1..5).include?(result.to_i) && Date.parse(date)

    return unless (user = User.find_by(telegram_id: from['id']))

    DailyRating.create!(user:, rating: result, rated_on: date)
    edit_message('text',
                 { text: "Gracias por tu feedback! \xF0\x9F\x98\x81 \xF0\x9F\x98\x81 \xF0\x9F\x98\x81" })
  end
end
