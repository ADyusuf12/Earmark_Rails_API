module Api
  module V1
    class ListingsController < ApplicationController
      include Rails.application.routes.url_helpers

      before_action :authenticate_user!
      before_action :set_listing, only: [ :show, :update, :destroy ]
      before_action :authorize_owner!, only: [ :update, :destroy ]

      def index
        listings = ListingsQuery.new(Listing.all, params).call
        render json: {
          listings: listings.map { |l| serialize_listing(l) },
          meta: {
            current_page: listings.current_page,
            next_page: listings.next_page,
            prev_page: listings.prev_page,
            total_pages: listings.total_pages,
            total_count: listings.total_count
          }
        }, status: :ok
      end

      def show
        render json: serialize_listing(@listing), status: :ok
      end

      def create
        listing = current_user.listings.build(listing_params)
        if listing.save
          render json: serialize_listing(listing), status: :created
        else
          render json: { errors: listing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @listing.update(listing_params)
          render json: serialize_listing(@listing), status: :ok
        else
          render json: { errors: @listing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @listing.destroy
        head :no_content
      end

      private

      def set_listing
        @listing = Listing.find(params[:id])
      end

      def authorize_owner!
        return if @listing.user == current_user
        render json: { errors: [ "Not authorized" ] }, status: :forbidden
      end

      def listing_params
        params.require(:listing).permit(:title, :description, :price, :location, images: [])
      end

      def serialize_listing(listing)
        listing.as_json(only: [ :id, :title, :description, :price, :location, :created_at, :updated_at ]).merge(
          user: {
            id: listing.user.id,
            username: listing.user.username,
            email: listing.user.email
          },
          images: listing.images.map { |img| url_for(img) }
        )
      end
    end
  end
end
