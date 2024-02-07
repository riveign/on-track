FactoryBot.define do
  factory :habit do
    name { 'MyString' }
    description { 'MyText' }
    habit_type
    user
    active_days { %w[0 1 2 3 4 5 6] }
  end
end
