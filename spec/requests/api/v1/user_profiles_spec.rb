require "rails_helper"

RSpec.describe "UserProfiles API", type: :request do
  let(:user) do
    create(:user,
           email: "user@example.com",
           username: "tester",
           password: "password123",
           password_confirmation: "password123",
           account_type: "customer")
  end

  let(:resource_url) { "/api/v1/user_profile" }

  before do
    post "/api/v1/login", params: {
      user: {
        email: user.email,
        password: "password123"
      }
    }, as: :json

    @token = JSON.parse(response.body)["access"]
  end

  let(:headers) { { "Authorization" => "Bearer #{@token}" } }

  describe "GET /api/v1/user_profile" do
    context "when authenticated" do
      it "returns the current user's profile" do
        get resource_url, headers: headers, as: :json

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)

        expect(body.dig("user", "email")).to eq(user.email)
        expect(body.dig("user", "username")).to eq(user.username)
        expect(body.dig("user", "account_type")).to eq("customer")
      end
    end

    context "when unauthenticated" do
      it "returns 401 Unauthorized" do
        get resource_url
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/v1/user_profile" do
    context "when authenticated" do
      it "updates first_name and last_name" do
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
        expect(JSON.parse(response.body).dig("profile", "profile_picture_url")).to match(/rails\/active_storage\/blobs/)
      end
    end

    context "when unauthenticated" do
      it "returns 401 Unauthorized" do
        patch resource_url, params: { user_profile: { first_name: "NoAuth" } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
