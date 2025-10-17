module Api
  module V1
    module Dashboard
      class ListingsController < ApplicationController
        include Pundit::Authorization

        before_action :authenticate_user!
        before_action :set_listing, only: [ :show, :update, :destroy ]

        def index
          listings = current_user.listings.order(created_at: :desc)
          render json: listings.map { |l| serialize_listing(l) }, status: :ok
        end

        def show
          authorize @listing
          render json: serialize_listing(@listing), status: :ok
        end

        def create
          listing = current_user.listings.build(listing_params)
          authorize listing

          if listing.save
            render json: serialize_listing(listing), status: :created
          else
            render json: { errors: listing.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          authorize @listing

          if @listing.update(listing_params)
            render json: serialize_listing(@listing), status: :ok
          else
            render json: { errors: @listing.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          authorize @listing
          @listing.destroy
          head :no_content
        end

        private

        def set_listing
          @listing = current_user.listings.find(params[:id])
        end

        def listing_params
          params.require(:listing).permit(:title, :description, :price, :location, images: [])
        end

        def serialize_listing(listing)
          listing.as_json(only: [ :id, :title, :description, :price, :location, :created_at, :updated_at ]).merge(
            images: listing.images.map { |img| Rails.application.routes.url_helpers.rails_blob_path(img, only_path: true) }
          )
        end
      end
    end
  end
end
