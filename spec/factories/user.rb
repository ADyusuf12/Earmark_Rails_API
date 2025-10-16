FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username }
    password { "password123" }
    password_confirmation { "password123" }

    transient do
      account_type { "customer" } # default role for tests unless overridden
    end

    # Pass account_type into the model so the after_create callback can use it
    before(:create) do |user, evaluator|
      user.account_type = evaluator.account_type
    end

    trait :admin do
      admin { true }
    end

    # Trait for enriched profile
    trait :with_enriched_profile do
      after(:create) do |user|
        user.user_profile.update!(
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.cell_phone_in_e164,
          bio: Faker::Lorem.sentence(word_count: 10)
        )
      end
    end

    # Trait for profile with picture
    trait :with_profile_picture do
      after(:create) do |user|
        user.user_profile.profile_picture.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/test.jpg")),
          filename: "test.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end
end
