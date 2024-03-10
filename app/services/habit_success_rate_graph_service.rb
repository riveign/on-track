class HabitSuccessRateGraphService
  def initialize(user, start_date = 30.days.ago.to_date, end_date = Date.current)
    @user = user
    @start_date = start_date
    @end_date = end_date
  end

  def calculate
    completed_habits_data = {}
    calculate_completed_habits_data(completed_habits_data)
    ensure_all_dates_present(completed_habits_data)
    completed_habits_data.sort.to_h
  end

  private

  def calculate_completed_habits_data(completed_habits_data)
    daily_habits.each do |daily_habit|
      date_key = daily_habit.created_at.to_date.to_s
      habit_name = daily_habit.habit.name
      completed_habits_data[date_key] ||= {}
      completed_habits_data[date_key][habit_name] = (completed_habits_data[date_key][habit_name] || 0) + 1
    end
  end

  def ensure_all_dates_present(completed_habits_data)
    (@start_date..@end_date).each do |date|
      date_key = date.to_s
      completed_habits_data[date_key] ||= {}
    end
  end

  def daily_habits
    @user.daily_habits.where(done: true)
         .where('DATE(created_at) >= ? AND DATE(created_at) <= ?', @start_date, @end_date)
         .includes(:habit)
  end
end
