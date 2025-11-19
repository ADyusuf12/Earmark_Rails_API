require "rails_helper"

RSpec.describe "Enquiries API", type: :request do
  let(:user) { create(:user) }
  let(:owner) { create(:user) }
  let(:listing) { create(:listing, user: owner) }
  let(:headers) { { "Authorization" => "Bearer #{jwt_token_for(user)}" } }
  let(:owner_headers) { { "Authorization" => "Bearer #{jwt_token_for(owner)}" } }

  describe "POST /api/v1/listings/:listing_id/enquiries" do
    it "creates an enquiry and its first message" do
      post "/api/v1/listings/#{listing.id}/enquiries",
           params: { enquiry: { message: "Is this still available?" } },
           headers: headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)

      # Enquiry metadata
      expect(json["listing_id"]).to eq(listing.id)
      expect(json["sender"]["id"]).to eq(user.id)

      # First message in thread
      expect(json["messages"].first["body"]).to eq("Is this still available?")
    end

    it "rejects invalid enquiry" do
      post "/api/v1/listings/#{listing.id}/enquiries",
           params: { enquiry: { message: "" } },
           headers: headers

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Message can't be blank")
    end
  end

  describe "GET /api/v1/listings/:listing_id/enquiries" do
    before do
      create(:enquiry, listing: listing, user: user, message: "Hello owner")
    end

    it "allows the owner to view enquiries for their listing" do
      get "/api/v1/listings/#{listing.id}/enquiries", headers: owner_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["messages"].first["body"]).to eq("Hello owner")
    end

    it "forbids non-owners from viewing enquiries" do
      get "/api/v1/listings/#{listing.id}/enquiries", headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /api/v1/enquiries" do
    before do
      create(:enquiry, listing: listing, user: user, message: "Interested in this property")
    end

    it "returns enquiries sent by the current user" do
      get "/api/v1/enquiries", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["messages"].first["body"]).to eq("Interested in this property")
      expect(json.first["sender"]["id"]).to eq(user.id)
    end
  end
end
