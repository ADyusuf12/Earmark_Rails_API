FactoryBot.define do
  factory :enquiry do
    association :user
    association :listing
    message { "I am interested in this property." }
  end
end
