# app/helpers/application_helper.rb

module ApplicationHelper
  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def rating_emoji(rating)
    case rating
    when 1
      '😔' # Least happy
    when 2
      '🙁'
    when 3
      '😐'
    when 4
      '🙂'
    when 5
      '😄' # Most happy
    else
      '' # No emoji
    end
  end
end
