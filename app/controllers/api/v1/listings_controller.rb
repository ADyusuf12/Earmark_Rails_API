module Api
  module V1
    class ListingsController < ApplicationController
      include Pundit::Authorization
      include Rails.application.routes.url_helpers

      before_action :set_listing, only: [ :show ]

      def index
        listings = ListingsQuery.new(Listing.all, query_params).call
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

      private

      def set_listing
        @listing = Listing.find(params[:id])
      end

      def query_params
        params.permit(:location, :min_price, :max_price, :q, :sort, :page, :per_page)
      end

      def serialize_listing(listing)
        listing.as_json(
          only: [ :id, :title, :description, :price, :location, :created_at, :updated_at ]
        ).merge(
          user: {
            id: listing.user.id,
            username: listing.user.username,
            email: listing.user.email
          },
          images: listing.images.map do |img|
            Rails.application.routes.url_helpers.rails_blob_path(img, only_path: true)
          end
        )
      end
    end
  end
end
