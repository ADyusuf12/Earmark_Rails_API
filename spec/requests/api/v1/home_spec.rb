require 'rails_helper'
RSpec.describe "API V1 Home", type: :request do
  describe "GET /api/v1/home" do
    it "returns a welcome message" do
      get "/api/v1/home"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Welcome to the API v1 Home!")
    end
  end
end
