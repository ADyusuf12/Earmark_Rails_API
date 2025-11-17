require "rails_helper"

RSpec.describe "Registrations API", type: :request do
  def json
    JSON.parse(response.body)
  end

  describe "POST /api/v1/register" do
    it "registers a new user" do
      post "/api/v1/register", params: {
        user: {
          email: "newuser@example.com",
          username: "newbie",
          password: "password123",
          password_confirmation: "password123",
          account_type: "customer"
        }
      }, as: :json

      expect(response).to have_http_status(:ok)
      expect(json["access"]).to be_present
      expect(json["user"]["email"]).to eq("newuser@example.com")
      expect(json["user"]["account_type"]).to eq("customer")
    end

    it "rejects invalid data" do
      post "/api/v1/register", params: {
        user: {
          email: "bademail",
          username: "",
          password: "short",
          password_confirmation: "mismatch",
          account_type: "customer"
        }
      }, as: :json

      expect(response).to have_http_status(422)
      expect(json["errors"]).to be_present
    end

    context "with account types" do
      it "creates a user with customer account_type" do
        post "/api/v1/register", params: {
          user: {
            email: "cust@example.com",
            username: "custy",
            password: "password123",
            password_confirmation: "password123",
            account_type: "customer"
          }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(json["user"]["account_type"]).to eq("customer")
      end

      it "creates a user with agent account_type" do
        post "/api/v1/register", params: {
          user: {
            email: "agent@example.com",
            username: "agenty",
            password: "password123",
            password_confirmation: "password123",
            account_type: "agent"
          }
        }, as: :json

        expect(response).to have_http_status(:ok)
        expect(json["user"]["account_type"]).to eq("agent")
      end

      it "rejects invalid account_type" do
        post "/api/v1/register", params: {
          user: {
            email: "bad@example.com",
            username: "baddy",
            password: "password123",
            password_confirmation: "password123",
            account_type: "hacker"
          }
        }, as: :json

        expect(response).to have_http_status(422)
        expect(json["errors"]).to include(
          "account_type must be one of: #{User.account_types.keys.join(', ')}"
        )
      end
    end
  end
end
