require 'faker'

FactoryBot.define do
  factory :habit_type do
    name { Faker::Name.name }
  end
end
