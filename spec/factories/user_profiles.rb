FactoryBot.define do
  factory :user_profile do
    association :user, factory: :user, strategy: :build
    first_name   { Faker::Name.first_name }
    last_name    { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    bio          { Faker::Lorem.sentence(word_count: 10) }

    trait :with_profile_picture do
      after(:build) do |profile|
        profile.profile_picture.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/test.jpg")),
          filename: "test.jpg",
          content_type: "image/jpeg"
        )
      end
    end

    trait :minimal do
      first_name { nil }
      last_name { nil }
      phone_number { nil }
      bio { nil }
    end
  end
end
