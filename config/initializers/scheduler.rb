require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 3 * * *' do
  DailyHabitCreationJob.perform_later
end

scheduler.cron '0 12,18 * * *' do
  DailyHabitNotificationJob.perform_later
end

scheduler.cron '0 17,20 * * *' do
  DailyHabitConfirmationJob.perform_later
end

scheduler.cron '0 16,21 * * *' do
  ReminderConfirmationJob.perform_later
end

scheduler.cron '0 15,20 * * *' do
  UpcomingReminderNotificationJob.perform_later
end
