require "rails_helper"

RSpec.describe EnquiryPolicy do
  let(:owner)    { create(:user, account_type: "property_owner") }
  let(:enquirer) { create(:user, account_type: "customer") }
  let(:listing)  { create(:listing, user: owner) }
  let(:enquiry)  { create(:enquiry, user: enquirer, listing: listing) }

  describe "#create?" do
    it "allows any authenticated user" do
      expect(described_class.new(enquirer, enquiry).create?).to eq(true)
      expect(described_class.new(owner, enquiry).create?).to eq(true)
    end

    it "denies nil user" do
      expect(described_class.new(nil, enquiry).create?).to eq(false)
    end
  end

  describe "#show?" do
    it "allows the enquirer" do
      expect(described_class.new(enquirer, enquiry).show?).to eq(true)
    end

    it "allows the listing owner" do
      expect(described_class.new(owner, enquiry).show?).to eq(true)
    end

    it "denies unrelated users" do
      stranger = create(:user, account_type: "customer")
      expect(described_class.new(stranger, enquiry).show?).to eq(false)
    end
  end
end
