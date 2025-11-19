require "rails_helper"

RSpec.describe "Messages API", type: :request do
  let(:owner)    { create(:user) }
  let(:enquirer) { create(:user) }
  let(:listing)  { create(:listing, user: owner) }
  let(:enquiry)  { create(:enquiry, user: enquirer, listing: listing, message: "Initial enquiry") }
  let(:headers)       { { "Authorization" => "Bearer #{jwt_token_for(enquirer)}" } }
  let(:owner_headers) { { "Authorization" => "Bearer #{jwt_token_for(owner)}" } }

  describe "GET /api/v1/listings/:listing_id/enquiries/:enquiry_id/messages" do
    before do
      create(:message, enquiry: enquiry, sender: enquirer, body: "Hello owner")
    end

    it "allows the enquirer to view messages" do
      get "/api/v1/listings/#{listing.id}/enquiries/#{enquiry.id}/messages", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.map { |m| m["body"] }).to include("Hello owner")
    end

    it "allows the owner to view messages" do
      get "/api/v1/listings/#{listing.id}/enquiries/#{enquiry.id}/messages", headers: owner_headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.map { |m| m["body"] }).to include("Hello owner")
    end

    it "forbids unrelated users" do
      stranger = create(:user)
      stranger_headers = { "Authorization" => "Bearer #{jwt_token_for(stranger)}" }
      get "/api/v1/listings/#{listing.id}/enquiries/#{enquiry.id}/messages", headers: stranger_headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /api/v1/listings/:listing_id/enquiries/:enquiry_id/messages" do
    it "allows the enquirer to post a message" do
      post "/api/v1/listings/#{listing.id}/enquiries/#{enquiry.id}/messages",
           params: { body: "Follow-up question" },
           headers: headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["body"]).to eq("Follow-up question")
      expect(json["sender"]["id"]).to eq(enquirer.id)
    end

    it "allows the owner to post a message" do
      post "/api/v1/listings/#{listing.id}/enquiries/#{enquiry.id}/messages",
           params: { body: "Yes, it is available" },
           headers: owner_headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["body"]).to eq("Yes, it is available")
      expect(json["sender"]["id"]).to eq(owner.id)
    end

    it "rejects invalid message" do
      post "/api/v1/listings/#{listing.id}/enquiries/#{enquiry.id}/messages",
           params: { body: "" },
           headers: headers

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Body can't be blank")
    end

    it "forbids unrelated users from posting" do
      stranger = create(:user)
      stranger_headers = { "Authorization" => "Bearer #{jwt_token_for(stranger)}" }
      post "/api/v1/listings/#{listing.id}/enquiries/#{enquiry.id}/messages",
           params: { body: "Trying to sneak in" },
           headers: stranger_headers

      expect(response).to have_http_status(:forbidden)
    end
  end
end
