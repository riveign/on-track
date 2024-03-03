# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test+1@email.com' }
    password { 'securepassword' }
  end

  factory :daily_rating do
    rating { 3 }
    rated_on { Date.today }
    association :user
  end
end
