require "rails_helper"

RSpec.describe "SavedListings API", type: :request do
  let(:user) { create(:user, password: "password123") }
  let!(:listing) { create(:listing, user: user, title: "Test Listing", price: 100.0, location: "Abuja") }

  before do
    post "/api/v1/login", params: {
      user: { email: user.email, password: "password123" }
    }, as: :json
    @token = JSON.parse(response.body)["access"]
  end

  let(:headers) { { "Authorization" => "Bearer #{@token}" } }
  let(:resource_url) { "/api/v1/saved_listings" }

  def json
    JSON.parse(response.body)
  end

  describe "GET /api/v1/saved_listings" do
    before do
      # Pre-save a listing for the user
      post resource_url, params: { listing_id: listing.id }, headers: headers, as: :json
    end

    it "returns all saved listings for the current user" do
      get resource_url, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json).to be_an(Array)
      expect(json.first["id"]).to eq(listing.id)
      expect(json.first["title"]).to eq("Test Listing")
    end
  end

  describe "POST /api/v1/saved_listings" do
    it "saves a listing for the current user" do
      post resource_url, params: { listing_id: listing.id }, headers: headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json["message"]).to eq("Listing saved")
    end

    it "prevents saving the same listing twice" do
      post resource_url, params: { listing_id: listing.id }, headers: headers, as: :json
      post resource_url, params: { listing_id: listing.id }, headers: headers, as: :json
      expect(response).to have_http_status(422)
      expect(json["errors"]).to include("User Listing has already been saved")
    end
  end

  describe "DELETE /api/v1/saved_listings/:id" do
    before do
      post resource_url, params: { listing_id: listing.id }, headers: headers, as: :json
    end

    it "unsaves a listing for the current user" do
      delete "#{resource_url}/#{listing.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it "returns not found if the listing is not saved" do
      delete "#{resource_url}/999999", headers: headers
      expect(response).to have_http_status(:not_found)
      expect(json["errors"]).to include("Not found")
    end
  end

  describe "authorization" do
    let(:other_user) { create(:user, password: "password123") }
    let!(:other_listing) { create(:listing, user: other_user, title: "Other Listing") }

    it "denies access without a token" do
      get resource_url
      expect(response).to have_http_status(:unauthorized)

      post resource_url, params: { listing_id: listing.id }
      expect(response).to have_http_status(:unauthorized)

      delete "#{resource_url}/#{listing.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "prevents one user from deleting another user's saved listing" do
      # other_user saves a listing
      post "/api/v1/login", params: { user: { email: other_user.email, password: "password123" } }, as: :json
      other_token = JSON.parse(response.body)["access"]
      post resource_url, params: { listing_id: other_listing.id }, headers: { "Authorization" => "Bearer #{other_token}" }, as: :json

      # now try to delete with the first user's token
      delete "#{resource_url}/#{other_listing.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
      expect(json["errors"]).to include("Not authorized")
    end

    it "allows admin to delete any saved listing" do
      admin = create(:user, :admin, password: "password123", account_type: "property_owner")
      post "/api/v1/login", params: { user: { email: admin.email, password: "password123" } }, as: :json
      admin_token = JSON.parse(response.body)["access"]

      # user saves a listing
      post resource_url, params: { listing_id: listing.id }, headers: headers, as: :json

      # admin deletes it
      delete "#{resource_url}/#{listing.id}", headers: { "Authorization" => "Bearer #{admin_token}" }
      expect(response).to have_http_status(:no_content)
    end
  end
end
