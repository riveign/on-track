# app/services/daily_habit_service.rb

class DailyHabitService
  def initialize(user)
    @user = user
  end

  def find_habits_without_daily_habit
    return unless @user

    today_range = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day

    @user.habits.active.left_outer_joins(:daily_habits)
         .where.not(id: DailyHabit.select(:habit_id).where(created_at: today_range))
  end

  def create_daily_habits
    return unless @user

    habits_without_daily_habit = find_habits_without_daily_habit

    habits_without_daily_habit.each do |habit|
      DailyHabit.create(habit:, user: @user, done: false)
    rescue ActiveRecord::RecordInvalid => e
      puts "Validation error: #{e.message}"
    end
  end
end
