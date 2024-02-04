FactoryBot.define do
  factory :habit do
    name { 'MyString' }
    description { 'MyText' }
    habit_type
    user
  end
end
