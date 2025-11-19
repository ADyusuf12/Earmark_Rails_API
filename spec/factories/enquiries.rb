FactoryBot.define do
  factory :enquiry do
    association :user
    association :listing
    message { "I am interested in this property." }

    after(:create) do |enquiry|
      create(:message, enquiry: enquiry, sender: enquiry.user, body: enquiry.message)
    end
  end
end
