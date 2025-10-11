require 'rails_helper'

RSpec.describe Listing, type: :model do
  let(:user) { create(:user) }
  subject { described_class.new(title: "Sample Listing", description: "A nice place to stay", price: 100.0, location: "Lagos", user: user) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a title" do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it "is not valid with a negative price" do
    subject.price = -50
    expect(subject).not_to be_valid
  end

  it "is not valid without a location" do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it "is not valid without a description" do
    subject.description = nil
    expect(subject).not_to be_valid
  end

  it "is not valid if description exceeds 500 characters" do
    subject.description = "a" * 501
    expect(subject).not_to be_valid
  end

  it "belongs to a user" do
    expect(subject.user).to eq(user)
  end
end
