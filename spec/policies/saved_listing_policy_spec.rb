require "rails_helper"

RSpec.describe SavedListingPolicy do
  let(:user)     { create(:user, account_type: "customer") }
  let(:other)    { create(:user, account_type: "customer") }
  let(:admin)    { create(:user, :admin, account_type: "property_owner") }

  let(:listing)  { create(:listing, user: other) }
  let(:saved)    { create(:saved_listing, user: user, listing: listing) }

  describe "#index?" do
    it "allows any logged in user" do
      expect(described_class.new(user, SavedListing).index?).to eq(true)
      expect(described_class.new(admin, SavedListing).index?).to eq(true)
    end

    it "denies guests" do
      expect(described_class.new(nil, SavedListing).index?).to eq(false)
    end
  end

  describe "#create?" do
    it "allows any logged in user" do
      expect(described_class.new(user, SavedListing).create?).to eq(true)
      expect(described_class.new(admin, SavedListing).create?).to eq(true)
    end

    it "denies guests" do
      expect(described_class.new(nil, SavedListing).create?).to eq(false)
    end
  end

  describe "#destroy?" do
    it "allows the owner of the saved listing" do
      expect(described_class.new(user, saved).destroy?).to eq(true)
    end

    it "allows admin" do
      expect(described_class.new(admin, saved).destroy?).to eq(true)
    end

    it "denies other users" do
      expect(described_class.new(other, saved).destroy?).to eq(false)
    end

    it "denies guests" do
      expect(described_class.new(nil, saved).destroy?).to eq(false)
    end
  end
end
