# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test+1@email.com' }
    password { 'securepassword' }
  end
end
