module Api
  module V1
    module Dashboard
      class OverviewsController < ApplicationController
        include Pundit::Authorization

        before_action :authenticate_user!

        def show
          authorize :overview, :show?

          listings_scope = current_user.listings
          render json: {
            stats: {
              total_listings: listings_scope.count,
              total_images: ActiveStorage::Attachment
                               .where(record_type: "Listing", record_id: listings_scope.select(:id))
                               .count
            },
            recent_listings: listings_scope.order(created_at: :desc).limit(5).map { |l| serialize_listing(l) }
          }, status: :ok
        end

        private

        def serialize_listing(listing)
          listing.as_json(only: [ :id, :title, :price, :created_at ]).merge(
            images: listing.images.map { |img| Rails.application.routes.url_helpers.rails_blob_path(img, only_path: true) }
          )
        end
      end
    end
  end
end
