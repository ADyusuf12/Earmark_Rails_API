require "rails_helper"

RSpec.describe "Dashboard Overviews API", type: :request do
  let(:owner) do
    create(:user, account_type: "property_owner", password: "password123").tap do |u|
      create_list(:listing, 3, user: u)
    end
  end

  let(:agent)     { create(:user, account_type: "agent", password: "password123") }
  let(:developer) { create(:user, account_type: "property_developer", password: "password123") }
  let(:customer)  { create(:user, account_type: "customer", password: "password123") }
  let(:admin)     { create(:user, :admin, password: "password123") }

  let(:resource_url) { "/api/v1/dashboard/overview" }

  def login(user)
    post "/api/v1/login", params: { user: { email: user.email, password: "password123" } }, as: :json
    JSON.parse(response.body)["access"]
  end

  def auth_headers(user)
    { "Authorization" => "Bearer #{login(user)}" }
  end

  describe "GET /api/v1/dashboard/overview" do
    it "allows property_owner" do
      get resource_url, headers: auth_headers(owner)
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["stats"]["total_listings"]).to eq(3)
      expect(body["recent_listings"].size).to be <= 5
    end

    it "allows agent" do
      get resource_url, headers: auth_headers(agent)
      expect(response).to have_http_status(:ok)
    end

    it "allows property_developer" do
      get resource_url, headers: auth_headers(developer)
      expect(response).to have_http_status(:ok)
    end

    it "allows admin" do
      get resource_url, headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
    end

    it "forbids customer" do
      get resource_url, headers: auth_headers(customer)
      expect(response).to have_http_status(:forbidden)
    end

    it "requires authentication" do
      get resource_url
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
