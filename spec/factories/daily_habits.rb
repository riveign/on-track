FactoryBot.define do
  factory :daily_habit do
    habit
    user
    done { false }
  end
end
