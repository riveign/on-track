FactoryBot.define do
  factory :reminder do
    title { 'Reminder' }
    description { 'This is a reminder' }
    due_date { Time.now + 1.day }
    user
  end
end
