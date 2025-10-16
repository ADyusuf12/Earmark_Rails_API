require "rails_helper"

RSpec.describe "Listings API", type: :request do
  let(:user) { create(:user, account_type: "owner", password: "password123") }
  let!(:listing) { create(:listing, user: user, title: "Test Listing", price: 100.0, location: "Abuja") }

  before do
    post "/api/v1/login", params: { user: { email: user.email, password: "password123" } }, as: :json
    @token = JSON.parse(response.body)["access"]
  end

  let(:headers) { { "Authorization" => "Bearer #{@token}" } }
  let(:resource_url) { "/api/v1/listings" }

  def json
    JSON.parse(response.body)
  end

  describe "GET /api/v1/listings" do
    it "returns all listings" do
      get resource_url, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json["listings"].size).to eq(1)
    end

    context "with filters" do
      it "filters by location" do
        get resource_url, params: { location: "Abuja" }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json["listings"].first["location"]).to eq("Abuja")
      end

      it "filters by price range" do
        get resource_url, params: { min_price: 50, max_price: 200 }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json["listings"].first["price"]).to eq("100.0")
      end

      it "filters by keyword" do
        create(:listing, user: user, title: "Luxury Apartment", description: "In Lagos", price: 500, location: "Lagos")
        get resource_url, params: { q: "Apartment" }, headers: headers
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
        get resource_url, params: { sort: "price_asc" }, headers: headers
        expect(json["listings"].map { |l| l["price"].to_f }).to eq([ 50.0, 100.0, 1000.0 ])
      end

      it "sorts by price descending" do
        get resource_url, params: { sort: "price_desc" }, headers: headers
        expect(json["listings"].map { |l| l["price"].to_f }).to eq([ 1000.0, 100.0, 50.0 ])
      end

      it "sorts by newest first" do
        get resource_url, params: { sort: "newest" }, headers: headers
        timestamps = json["listings"].map { |l| l["created_at"] }
        expect(timestamps).to eq(timestamps.sort.reverse)
      end
    end

    context "with pagination" do
      before { create_list(:listing, 15, user: user, location: "Lagos", price: 150.0) }

      it "paginates listings" do
        get resource_url, params: { page: 1, per_page: 10 }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(json["listings"].size).to eq(10)
        expect(json["meta"]["total_pages"]).to eq(2)
      end
    end
  end

  describe "POST /api/v1/listings" do
    context "as owner" do
      it "creates a new listing" do
        post resource_url,
             params: { listing: { title: "New Listing", description: "Nice place", price: 200, location: "Abuja" } },
             headers: headers, as: :json
        expect(response).to have_http_status(:created)
      end

      it "creates a new listing with an image" do
        file = fixture_file_upload(Rails.root.join("spec/fixtures/files/test.jpg"), "image/jpeg")
        post resource_url,
             params: { listing: { title: "Listing with Image", description: "Has a photo", price: 300, location: "Lagos", images: [ file ] } },
             headers: headers
        expect(response).to have_http_status(:created)
      end
    end

    context "as customer" do
      it "is forbidden" do
        customer = create(:user, account_type: "customer", password: "password123")
        post "/api/v1/login", params: { user: { email: customer.email, password: "password123" } }, as: :json
        cust_token = JSON.parse(response.body)["access"]

        post resource_url,
             params: { listing: { title: "Blocked Listing", description: "Should not work", price: 50, location: "Nowhere" } },
             headers: { "Authorization" => "Bearer #{cust_token}" }, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as agent or developer" do
      %w[agent developer].each do |role|
        it "allows #{role} to create listings" do
          u = create(:user, account_type: role, password: "password123")
          post "/api/v1/login", params: { user: { email: u.email, password: "password123" } }, as: :json
          role_token = JSON.parse(response.body)["access"]

          post resource_url,
               params: { listing: { title: "#{role.capitalize} Listing", description: "Valid", price: 123, location: "Lagos" } },
               headers: { "Authorization" => "Bearer #{role_token}" }, as: :json
          expect(response).to have_http_status(:created)
        end
      end
    end
  end

  describe "PATCH /api/v1/listings/:id" do
    it "updates when owner" do
      patch "#{resource_url}/#{listing.id}", params: { listing: { price: 150 } }, headers: headers, as: :json
      expect(response).to have_http_status(:ok)
    end

    it "prevents non-owners" do
      other_user = create(:user, password: "password123", account_type: "owner")
      others_listing = create(:listing, user: other_user, title: "Other's Listing", price: 500)
      patch "#{resource_url}/#{others_listing.id}", params: { listing: { price: 999 } }, headers: headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "allows admin" do
      admin = create(:user, :admin, account_type: "owner", password: "password123")
      post "/api/v1/login", params: { user: { email: admin.email, password: "password123" } }, as: :json
      admin_token = JSON.parse(response.body)["access"]

      patch "#{resource_url}/#{listing.id}", params: { listing: { price: 777 } },
            headers: { "Authorization" => "Bearer #{admin_token}" }, as: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /api/v1/listings/:id" do
    it "deletes when owner" do
      delete "#{resource_url}/#{listing.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it "prevents non-owners" do
      other_user = create(:user, password: "password123", account_type: "owner")
      others_listing = create(:listing, user: other_user, title: "Other's Listing", price: 500)
      delete "#{resource_url}/#{others_listing.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
    end

    it "allows admin" do
      admin = create(:user, :admin, account_type: "owner", password: "password123")
      post "/api/v1/login", params: { user: { email: admin.email, password: "password123" } }, as: :json
      admin_token = JSON.parse(response.body)["access"]

      delete "#{resource_url}/#{listing.id}", headers: { "Authorization" => "Bearer #{admin_token}" }
      expect(response).to have_http_status(:no_content)
    end
  end
end
