# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@email.com' }
    password { 'securepassword' }
  end
end
