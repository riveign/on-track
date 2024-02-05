FactoryBot.define do
  factory :daily_habit do
    association :habit
    association :user
    done { false }
  end
end
