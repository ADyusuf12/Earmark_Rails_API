require "rails_helper"

RSpec.describe "Public Listings API", type: :request do
  let(:user) { create(:user, account_type: "owner", password: "password123") }
  let!(:listing) { create(:listing, user: user, title: "Test Listing", price: 100.0, location: "Abuja") }

  let(:resource_url) { "/api/v1/listings" }

  def json
    JSON.parse(response.body)
  end

  describe "GET /api/v1/listings" do
    it "returns all listings" do
      get resource_url
      expect(response).to have_http_status(:ok)
      expect(json["listings"].size).to eq(1)
    end

    context "with filters" do
      it "filters by location" do
        get resource_url, params: { location: "Abuja" }
        expect(response).to have_http_status(:ok)
        expect(json["listings"].first["location"]).to eq("Abuja")
      end

      it "filters by price range" do
        get resource_url, params: { min_price: 50, max_price: 200 }
        expect(response).to have_http_status(:ok)
        expect(json["listings"].first["price"]).to eq("100.0")
      end

      it "filters by keyword" do
        create(:listing, user: user, title: "Luxury Apartment", description: "In Lagos", price: 500, location: "Lagos")
        get resource_url, params: { q: "Apartment" }
        expect(response).to have_http_status(:ok)
        expect(json["listings"].first["title"]).to include("Apartment")
      end
    end

    context "with sorting" do
      before do
        create(:listing, user: user, title: "Cheap Listing", price: 50.0)
        create(:listing, user: user, title: "Expensive Listing", price: 1000.0)
      end

      it "sorts by price ascending" do
        get resource_url, params: { sort: "price_asc" }
        expect(json["listings"].map { |l| l["price"].to_f }).to eq([ 50.0, 100.0, 1000.0 ])
      end

      it "sorts by price descending" do
        get resource_url, params: { sort: "price_desc" }
        expect(json["listings"].map { |l| l["price"].to_f }).to eq([ 1000.0, 100.0, 50.0 ])
      end

      it "sorts by newest first" do
        get resource_url, params: { sort: "newest" }
        timestamps = json["listings"].map { |l| l["created_at"] }
        expect(timestamps).to eq(timestamps.sort.reverse)
      end
    end

    context "with pagination" do
      before { create_list(:listing, 15, user: user, location: "Lagos", price: 150.0) }

      it "paginates listings" do
        get resource_url, params: { page: 1, per_page: 10 }
        expect(response).to have_http_status(:ok)
        expect(json["listings"].size).to eq(10)
        expect(json["meta"]["total_pages"]).to eq(2)
      end
    end
  end

  describe "GET /api/v1/listings/:id" do
    it "returns a single listing" do
      get "#{resource_url}/#{listing.id}"
      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(listing.id)
      expect(json["title"]).to eq("Test Listing")
    end
  end
end
