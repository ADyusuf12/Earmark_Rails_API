require "rails_helper"

RSpec.describe "Registrations API", type: :request do
  describe "POST /api/v1/register" do
    it "registers a new user" do
      post "/api/v1/register", params: {
        user: {
          email: "newuser@example.com",
          username: "newbie",
          password: "password123",
          password_confirmation: "password123"
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["access"]).to be_present
      expect(json["user"]["email"]).to eq("newuser@example.com")
    end

    it "rejects invalid data" do
      post "/api/v1/register", params: {
        user: {
          email: "bademail",
          username: "",
          password: "short",
          password_confirmation: "mismatch"
        }
      }, as: :json

      expect(response).to have_http_status(422)
    end
  end
end
