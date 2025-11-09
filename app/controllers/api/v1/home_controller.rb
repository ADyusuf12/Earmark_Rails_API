module Api
  module V1
    class HomeController < ApplicationController
      def index
        render json: { message: "Welcome to the API v1 Home!" }
      end
    end
  end
end
