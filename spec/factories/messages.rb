FactoryBot.define do
  factory :message do
    association :enquiry
    association :sender, factory: :user
    body { "This is a test message body." }
  end
end
