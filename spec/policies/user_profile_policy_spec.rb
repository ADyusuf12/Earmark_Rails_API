require "rails_helper"

RSpec.describe UserProfilePolicy do
  let(:owner)  { create(:user, account_type: "owner") }
  let(:other)  { create(:user, account_type: "customer") }
  let(:admin)  { create(:user, :admin, account_type: "owner") }

  let(:owner_profile)  { owner.user_profile }
  let(:other_profile)  { other.user_profile }

  describe "#show?" do
    it "allows any logged-in user to view any profile" do
      expect(described_class.new(owner, owner_profile).show?).to eq(true)
      expect(described_class.new(owner, other_profile).show?).to eq(true)
      expect(described_class.new(admin, other_profile).show?).to eq(true)
    end

    it "denies guests" do
      expect(described_class.new(nil, owner_profile).show?).to eq(false)
    end
  end

  describe "#update?" do
    it "allows the owner of the profile" do
      expect(described_class.new(owner, owner_profile).update?).to eq(true)
    end

    it "allows admin to update any profile" do
      expect(described_class.new(admin, other_profile).update?).to eq(true)
    end

    it "denies other users" do
      expect(described_class.new(owner, other_profile).update?).to eq(false)
    end

    it "denies guests" do
      expect(described_class.new(nil, owner_profile).update?).to eq(false)
    end
  end
end
