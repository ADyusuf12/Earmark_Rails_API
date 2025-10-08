require "rails_helper"

RSpec.describe "Listings API", type: :request do
  let(:user) { create(:user, password: "password123") }
  let!(:listing) { create(:listing, user: user, title: "Test Listing", price: 100.0, location: "Abuja") }

  before do
    post "/api/v1/login", params: {
      user: { email: user.email, password: "password123" }
    }, as: :json
    @token = JSON.parse(response.body)["access"]
  end

  let(:headers) { { "Authorization" => "Bearer #{@token}" } }

  def json
    JSON.parse(response.body)
  end

  describe "GET /api/v1/listings" do
    it "returns all listings" do
      get "/api/v1/listings", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json["listings"]).to be_an(Array)
      expect(json["listings"].size).to eq(1)
      expect(json["listings"].first["title"]).to eq("Test Listing")
    end
  end

  describe "GET /api/v1/listings with filters" do
    it "filters listings by location" do
      get "/api/v1/listings", params: { location: "Abuja" }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json["listings"].size).to eq(1)
      expect(json["listings"].first["location"]).to eq("Abuja")
    end

    it "filters listings by price range" do
      get "/api/v1/listings", params: { min_price: 50, max_price: 200 }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json["listings"].size).to eq(1)
      expect(json["listings"].first["price"]).to eq("100.0")
    end
  end

  describe "GET /api/v1/listings with pagination" do
    before do
      create_list(:listing, 15, user: user, location: "Lagos", price: 150.0)
    end
    it "paginates listings" do
      get "/api/v1/listings", params: { page: 1, per_page: 10 }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json["listings"].size).to eq(10)
      expect(json["meta"]["total_pages"]).to eq(2)
      expect(json["meta"]["total_count"]).to eq(16) # 15 + the initial listing
    end
  end

  describe "POST /api/v1/listings" do
    it "creates a new listing" do
      post "/api/v1/listings",
           params: { listing: { title: "New Listing", description: "Nice place", price: 200, location: "Abuja" } },
           headers: headers,
           as: :json
      expect(response).to have_http_status(:created)
      expect(json["title"]).to eq("New Listing")
    end

    it "creates a new listing with an image" do
      file = fixture_file_upload(Rails.root.join("spec/fixtures/files/test.jpg"), "image/jpeg")

      post "/api/v1/listings",
           params: {
             listing: {
               title: "Listing with Image",
               description: "Has a photo",
               price: 300,
               location: "Lagos",
               images: [ file ]
             }
           },
           headers: headers

      expect(response).to have_http_status(:created)
      expect(json["title"]).to eq("Listing with Image")
      expect(json["images"]).to be_an(Array)
      expect(json["images"].first).to match(/rails\/active_storage\/blobs/)
    end
  end

  describe "PATCH /api/v1/listings/:id" do
    it "updates a listing when owner" do
      patch "/api/v1/listings/#{listing.id}",
            params: { listing: { price: 150 } },
            headers: headers,
            as: :json
      expect(response).to have_http_status(:ok)
      expect(json["price"]).to eq("150.0")
    end

    it "prevents non-owners from updating a listing" do
      other_user = create(:user, password: "password123")
      others_listing = create(:listing, user: other_user, title: "Other's Listing", price: 500, location: "Lagos")

      patch "/api/v1/listings/#{others_listing.id}",
            params: { listing: { price: 999 } },
            headers: headers,
            as: :json
      expect(response).to have_http_status(:forbidden)
      expect(json["errors"]).to include("Not authorized")
    end
  end

  describe "DELETE /api/v1/listings/:id" do
    it "deletes a listing when owner" do
      delete "/api/v1/listings/#{listing.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it "prevents non-owners from deleting a listing" do
      other_user = create(:user, password: "password123")
      others_listing = create(:listing, user: other_user, title: "Other's Listing", price: 500, location: "Lagos")

      delete "/api/v1/listings/#{others_listing.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
      expect(json["errors"]).to include("Not authorized")
    end
  end
end
