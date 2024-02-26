require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 * * * *' do
  DailyHabitCreationJob.perform_later
end

scheduler.cron '0 * * * *' do
  DailyHabitNotificationJob.perform_later
end

scheduler.cron '0 */2 * * *' do
  DailyHabitConfirmationJob.perform_later
end

scheduler.cron '0 */4 * * *' do
  ReminderConfirmationJob.perform_later
end

scheduler.cron '0 */6 * * *' do
  UpcomingReminderNotificationJob.perform_later
end

scheduler.cron '0 * * * *' do
  StartDayNotificationJob.perform_later
end
