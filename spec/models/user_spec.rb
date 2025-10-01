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
  end

  describe "callbacks" do
    it "creates a default user_profile after creation" do
      user = create(:user)
      expect(user.user_profile).to be_present
      expect(user.user_profile.account_type).to eq("customer")
    end
  end
end
