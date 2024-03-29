FactoryBot.define do
  factory :habit do
    name { 'MyString' }
    description { 'MyText' }
    habit_type
    user
    active_days { %w[1 2 3 4 5 6 7] }
    trait :inactive do
      active_days { [] }
    end
  end
end
