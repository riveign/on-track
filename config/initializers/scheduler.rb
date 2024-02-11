require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 3 * * *' do
  DailyHabitCreationJob.perform_later
end

scheduler.cron '0 12,18 * * *' do
  DailyHabitNotificationJob.perform_later
end

scheduler.cron '0 15,20 * * *' do
  ReminderNotificationJob.perform_later
end
