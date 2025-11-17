require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }  # ensures valid baseline

  describe "associations" do
    it { should have_one(:user_profile).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:username) }

    it "validates uniqueness of username case-insensitively" do
      create(:user, username: "tester", email: "unique1@example.com")
      duplicate = build(:user, username: "TESTER", email: "unique2@example.com")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:username]).to include("has already been taken")
    end

    it "requires account_type to be present and valid" do
      expect(build(:user, account_type: nil)).not_to be_valid
      expect(build(:user, account_type: "customer")).to be_valid
      expect(build(:user, account_type: "agent")).to be_valid
      expect(build(:user, account_type: "property_developer")).to be_valid
      expect(build(:user, account_type: "property_owner")).to be_valid
    end
  end

  describe "callbacks" do
    it "creates a default user_profile after creation" do
      user = create(:user, account_type: "customer")
      expect(user.user_profile).to be_present
      # profile no longer has account_type, just personal info
      expect(user.user_profile.first_name).to be_nil
    end
  end

  describe "enums" do
    it "defines account_type enum values" do
      expect(User.account_types.keys).to contain_exactly(
        "customer", "agent", "property_developer", "property_owner"
      )
    end

    it "defines role enum values" do
      expect(User.roles.keys).to contain_exactly("user", "admin")
    end
  end
end
