FactoryBot.define do
  factory :user_profile do
    association :user
    account_type { "customer" }

    trait :agent do
      account_type { "agent" }
    end

    trait :developer do
      account_type { "developer" }
    end

    trait :owner do
      account_type { "owner" }
    end
  end
end
