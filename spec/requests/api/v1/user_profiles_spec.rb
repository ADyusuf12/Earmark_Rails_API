require "rails_helper"

RSpec.describe "UserProfiles API", type: :request do
  let(:user) do
    create(:user,
           email: "user@example.com",
           username: "tester",
           password: "password123",
           password_confirmation: "password123")
  end

  let(:resource_url) { "/api/v1/user_profile" }

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

  describe "GET /api/v1/user_profile" do
    it "returns the current user's profile" do
      get resource_url, headers: headers, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      expect(body.dig("user", "email")).to eq(user.email)
      expect(body.dig("user", "username")).to eq(user.username)
      expect(body.dig("profile", "account_type")).to eq("customer")
      expect(body.dig("profile", "first_name")).to eq(user.user_profile.first_name)
      expect(body.dig("profile", "last_name")).to eq(user.user_profile.last_name)
    end
  end

  describe "PATCH /api/v1/user_profile" do
    it "updates account_type when valid" do
      patch resource_url,
            params: { user_profile: { account_type: "agent" } },
            headers: headers,
            as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("profile", "account_type")).to eq("agent")
    end

    it "rejects invalid account_type" do
      patch resource_url,
            params: { user_profile: { account_type: "hacker" } },
            headers: headers,
            as: :json

      expect(response).to have_http_status(422)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include(/Account type/i)
    end

    it "updates first_name and last_name when valid" do
      patch resource_url,
            params: { user_profile: { first_name: "John", last_name: "Doe" } },
            headers: headers,
            as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("profile", "first_name")).to eq("John")
      expect(body.dig("profile", "last_name")).to eq("Doe")
    end

    it "updates phone_number and bio" do
      patch resource_url,
            params: { user_profile: { phone_number: "08012345678", bio: "Agent in Abuja" } },
            headers: headers,
            as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("profile", "phone_number")).to eq("08012345678")
      expect(body.dig("profile", "bio")).to eq("Agent in Abuja")
    end

    it "uploads a profile picture" do
      file = fixture_file_upload(Rails.root.join("spec/fixtures/files/test.jpg"), "image/jpeg")

      patch resource_url,
            params: { user_profile: { profile_picture: file } },
            headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.dig("profile", "profile_picture_url")).to match(/rails\/active_storage\/blobs/)
    end
  end
end
