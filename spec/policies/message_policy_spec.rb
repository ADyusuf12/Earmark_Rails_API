require "rails_helper"

RSpec.describe MessagePolicy do
  let(:owner)    { create(:user, account_type: "property_owner") }
  let(:enquirer) { create(:user, account_type: "customer") }
  let(:listing)  { create(:listing, user: owner) }
  let(:enquiry)  { create(:enquiry, user: enquirer, listing: listing) }
  let(:message)  { create(:message, enquiry: enquiry, sender: enquirer) }

  describe "#index?" do
    it "allows the enquirer" do
      expect(described_class.new(enquirer, message).index?).to eq(true)
    end

    it "allows the listing owner" do
      expect(described_class.new(owner, message).index?).to eq(true)
    end

    it "denies unrelated users" do
      stranger = create(:user)
      expect(described_class.new(stranger, message).index?).to eq(false)
    end
  end

  describe "#create?" do
    it "allows the enquirer" do
      expect(described_class.new(enquirer, message).create?).to eq(true)
    end

    it "allows the listing owner" do
      expect(described_class.new(owner, message).create?).to eq(true)
    end

    it "denies unrelated users" do
      stranger = create(:user)
      expect(described_class.new(stranger, message).create?).to eq(false)
    end
  end
end
