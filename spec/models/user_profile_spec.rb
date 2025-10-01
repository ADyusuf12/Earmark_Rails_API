require "rails_helper"

RSpec.describe UserProfile, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:account_type) }

    it "allows only valid account types" do
      UserProfile::ACCOUNT_TYPES.each do |type|
        profile = build(:user_profile, account_type: type)
        expect(profile).to be_valid
      end

      invalid_profile = build(:user_profile, account_type: "hacker")
      expect(invalid_profile).not_to be_valid
      expect(invalid_profile.errors[:account_type]).to include("is not included in the list")
    end
  end
end
