require "rails_helper"

RSpec.describe "Dashboard Listings API", type: :request do
  let(:user) { create(:user, account_type: "property_owner", password: "password123") }
  let(:other_user) { create(:user, account_type: "property_owner", password: "password123") }

  let!(:listings) { create_list(:listing, 3, user: user) }
  let!(:other_listing) { create(:listing, user: other_user) }

  let(:resource_url) { "/api/v1/dashboard/listings" }

  def login(user)
    post "/api/v1/login", params: { user: { email: user.email, password: "password123" } }, as: :json
    JSON.parse(response.body)["access"]
  end

  def auth_headers(user)
    { "Authorization" => "Bearer #{login(user)}" }
  end

  describe "GET /dashboard/listings" do
    it "returns only the current user's listings" do
      get resource_url, headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.size).to eq(3)
      expect(body.map { |l| l["id"] }).not_to include(other_listing.id)
    end
  end

  describe "GET /dashboard/listings/:id" do
    it "shows a listing owned by the user" do
      get "#{resource_url}/#{listings.first.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(listings.first.id)
    end

    it "forbids access to another user's listing" do
      get "#{resource_url}/#{other_listing.id}", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /dashboard/listings" do
    let(:valid_params) do
      {
        listing: {
          title: "New Listing",
          description: "A great place",
          location: "Abuja",
          price: 1000
        }
      }
    end

    it "creates a listing for the current user" do
      post resource_url, params: valid_params, headers: auth_headers(user)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["title"]).to eq("New Listing")
    end
  end

  describe "PATCH /dashboard/listings/:id" do
    it "updates a listing owned by the user" do
      patch "#{resource_url}/#{listings.first.id}",
            params: { listing: { title: "Updated Title" } },
            headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("Updated Title")
    end
  end

  describe "DELETE /dashboard/listings/:id" do
    it "deletes a listing owned by the user" do
      expect {
        delete "#{resource_url}/#{listings.first.id}", headers: auth_headers(user)
      }.to change { Listing.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
