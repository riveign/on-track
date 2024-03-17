# Service to update a daily habit status
class DailyHabitUpdateService
  include EmojisHelper
  def self.perform(value)
    new(value).perform
  end

  def initialize(value)
    @value = value
  end

  def perform
    if @value == 'no'
      { text: "#{I18n.t('telegram.daily_habit.motivation')}	#{emoji(:strength, 3)} " }
    elsif DailyHabit.find(@value).update!(done: true)
      { text: "#{I18n.t('telegram.daily_habit.congratulations')}  #{emoji(:celebration, 3)} " }
    end
  end
end
