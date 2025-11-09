FactoryBot.define do
  factory :listing do
    title       { "Sample Listing" }
    description { "A nice description of the property." }
    price       { 100.0 }
    location    { "Lagos" }
    association :user   # ensures a valid user is created and linked
  end
end
