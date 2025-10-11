FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    username { Faker::Internet.unique.username }
    password { "password123" }
    password_confirmation { "password123" }

    # # Automatically build an associated user_profile
    # after(:create) do |user|
    #   create(:user_profile, user: user)
    # end

    # Trait for enriched profile
    trait :with_enriched_profile do
      after(:create) do |user|
        create(:user_profile,
               user: user,
               first_name: Faker::Name.first_name,
               last_name: Faker::Name.last_name,
               phone_number: Faker::PhoneNumber.cell_phone_in_e164,
               bio: Faker::Lorem.sentence(word_count: 10))
      end
    end

    # Trait for profile with picture
    trait :with_profile_picture do
      after(:create) do |user|
        create(:user_profile, :with_profile_picture, user: user)
      end
    end
  end
end
