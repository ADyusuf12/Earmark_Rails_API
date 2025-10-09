FactoryBot.define do
  factory :user_profile do
    association :user
    account_type { "customer" }
    first_name   { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    bio          { Faker::Lorem.sentence(word_count: 10) }

    trait :agent do
      account_type { "agent" }
    end

    trait :developer do
      account_type { "developer" }
    end

    trait :owner do
      account_type { "owner" }
    end

    trait :with_profile_picture do
      after(:build) do |profile|
        profile.profile_picture.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/test.jpg")),
          filename: "test.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end
end
