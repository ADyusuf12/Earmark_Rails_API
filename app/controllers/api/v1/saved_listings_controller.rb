module Api
  module V1
    class SavedListingsController < ApplicationController
      respond_to :json
      before_action :authenticate_user!

      def index
        authorize SavedListing
        saved = current_user.saved_listings.includes(:listing)
        render json: saved.map { |s| serialize_listing(s.listing) }, status: :ok
      end

      def create
        authorize SavedListing
        saved = current_user.saved_listings.build(listing_id: params[:listing_id])
        if saved.save
          render json: { message: "Listing saved" }, status: :created
        else
          render json: { errors: saved.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        saved = SavedListing.find_by(listing_id: params[:id])
        if saved
          authorize saved
          saved.destroy
          head :no_content
        else
          render json: { errors: [ "Not found" ] }, status: :not_found
        end
      end

      private

      def serialize_listing(listing)
        listing.as_json(only: [ :id, :title, :price, :location ])
      end
    end
  end
end
