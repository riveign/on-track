class DailyHabitGraphService
  def initialize(user, start_date = 30.days.ago.to_date, end_date = Date.current)
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def calculate
    habits_data = @user.habits.each_with_object({}) do |habit, hash|
      completed_data = habit.daily_habits
                            .where(done: true)
                            .where('created_at >= ? AND created_at <= ?', @start_date, @end_date)
                            .group_by_day(:created_at, range: @start_date..@end_date)
                            .count

      hash[habit.name] = completed_data unless completed_data.empty?
    end

    format_for_chartkick(habits_data)
  end

  private

  def format_for_chartkick(habits_data)
    habits_data.map do |habit_name, data|
      {
        name: habit_name,
        data:
      }
    end
  end
end
