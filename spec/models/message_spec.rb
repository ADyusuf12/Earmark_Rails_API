require "rails_helper"

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:listing) { create(:listing, user: user) }
  let(:enquiry) { create(:enquiry, user: user, listing: listing) }

  it "is valid with an enquiry, sender, and body" do
    message = described_class.new(enquiry: enquiry, sender: user, body: "Valid body")
    expect(message).to be_valid
  end

  it "is invalid without a body" do
    message = described_class.new(enquiry: enquiry, sender: user, body: "")
    expect(message).not_to be_valid
    expect(message.errors[:body]).to include("can't be blank")
  end

  it "is invalid without a sender" do
    message = described_class.new(enquiry: enquiry, body: "Hello")
    expect(message).not_to be_valid
    expect(message.errors[:sender]).to include("must exist")
  end

  it "is invalid without an enquiry" do
    message = described_class.new(sender: user, body: "Hello")
    expect(message).not_to be_valid
    expect(message.errors[:enquiry]).to include("must exist")
  end
end
