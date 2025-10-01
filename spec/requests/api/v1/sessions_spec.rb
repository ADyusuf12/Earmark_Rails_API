require "rails_helper"

RSpec.describe "Sessions API", type: :request do
  let!(:user) { create(:user, password: "password123") }

  describe "POST /api/v1/login" do
    it "logs in with valid credentials" do
      post "/api/v1/login", params: {
        user: { email: user.email, password: "password123" }
      }, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["access"]).to be_present
      expect(json["user"]["email"]).to eq(user.email)
    end

    it "rejects invalid credentials" do
      post "/api/v1/login", params: {
        user: { email: user.email, password: "wrongpass" }
      }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
