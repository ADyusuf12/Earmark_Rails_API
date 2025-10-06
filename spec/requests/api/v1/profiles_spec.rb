require "rails_helper"

RSpec.describe "Profiles API", type: :request do
  let(:user) do
    create(:user,
           email: "user@example.com",
           username: "tester",
           password: "password123",
           password_confirmation: "password123")
  end

  before do
    # Log in through the API to get a real JWT
    post "/api/v1/login", params: {
      user: {
        email: user.email,
        password: "password123"
      }
    }, as: :json

    expect(response).to have_http_status(:ok) # sanity check
    @token = JSON.parse(response.body)["access"]
    expect(@token).to be_present
  end

  let(:headers) do
    {
      "Authorization" => "Bearer #{@token}"
    }
  end

  describe "GET /api/v1/profile" do
    it "returns the current user's profile" do
      get "/api/v1/profile", headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("user", "email")).to eq(user.email)
      expect(body.dig("profile", "account_type")).to eq("customer")
    end
  end

  describe "PATCH /api/v1/profile" do
    it "updates account_type when valid" do
      patch "/api/v1/profile",
            params: { profile: { account_type: "agent" } },
            headers: headers,
            as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("profile", "account_type")).to eq("agent")
    end

    it "rejects invalid account_type" do
      patch "/api/v1/profile",
            params: { profile: { account_type: "hacker" } },
            headers: headers,
            as: :json

      expect(response).to have_http_status(422)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include(/Account type/i)
    end

    it "updates first_name and last_name when valid" do
      patch "/api/v1/profile",
            params: { profile: { first_name: "John", last_name: "Doe" } },
            headers: headers,
            as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("profile", "first_name")).to eq("John")
      expect(body.dig("profile", "last_name")).to eq("Doe")
    end
  end
end
