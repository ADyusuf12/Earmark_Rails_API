require "rails_helper"

RSpec.describe ListingPolicy do
  let(:owner)     { create(:user, account_type: "property_owner") }
  let(:agent)     { create(:user, account_type: "agent") }
  let(:developer) { create(:user, account_type: "property_developer") }
  let(:customer)  { create(:user, account_type: "customer") }
  let(:admin)     { create(:user, :admin, account_type: "property_owner") }

  let(:owners_listing) { create(:listing, user: owner) }

  describe "#index?" do
    it "allows anyone" do
      expect(described_class.new(owner, owners_listing).index?).to eq(true)
      expect(described_class.new(customer, owners_listing).index?).to eq(true)
      expect(described_class.new(nil, owners_listing).index?).to eq(true)
    end
  end

  describe "#show?" do
    it "allows anyone" do
      expect(described_class.new(owner, owners_listing).show?).to eq(true)
      expect(described_class.new(customer, owners_listing).show?).to eq(true)
      expect(described_class.new(nil, owners_listing).show?).to eq(true)
    end
  end

  describe "#create?" do
    it "allows owner, agent, developer, admin" do
      expect(described_class.new(owner, Listing.new).create?).to eq(true)
      expect(described_class.new(agent, Listing.new).create?).to eq(true)
      expect(described_class.new(developer, Listing.new).create?).to eq(true)
      expect(described_class.new(admin, Listing.new).create?).to eq(true)
    end

    it "denies customer" do
      expect(described_class.new(customer, Listing.new).create?).to eq(false)
    end
  end

  describe "#update?" do
    it "allows admin on any listing" do
      expect(described_class.new(admin, owners_listing).update?).to eq(true)
    end

    it "allows owner of listing with correct role" do
      expect(described_class.new(owner, owners_listing).update?).to eq(true)
    end

    it "denies customer even if they own the listing" do
      cust_listing = create(:listing, user: customer)
      expect(described_class.new(customer, cust_listing).update?).to eq(false)
    end

    it "denies non‑owners" do
      other_owner = create(:user, account_type: "property_owner")
      others_listing = create(:listing, user: other_owner)
      expect(described_class.new(owner, others_listing).update?).to eq(false)
    end
  end

  describe "#destroy?" do
    it "behaves the same as update?" do
      expect(described_class.new(admin, owners_listing).destroy?).to eq(true)
      expect(described_class.new(owner, owners_listing).destroy?).to eq(true)
      cust_listing = create(:listing, user: customer)
      expect(described_class.new(customer, cust_listing).destroy?).to eq(false)
    end
  end

  describe "#show_enquiries?" do
    it "allows the owner of the listing" do
      expect(described_class.new(owner, owners_listing).show_enquiries?).to eq(true)
    end

    it "denies non‑owners" do
      expect(described_class.new(customer, owners_listing).show_enquiries?).to eq(false)
      expect(described_class.new(agent, owners_listing).show_enquiries?).to eq(false)
      expect(described_class.new(developer, owners_listing).show_enquiries?).to eq(false)
      expect(described_class.new(admin, owners_listing).show_enquiries?).to eq(true) # admin doesn’t own this listing
    end
  end
end
