module Api
  module V1
    class EnquiriesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_listing, only: [ :create, :index ]

      def create
        enquiry = @listing.enquiries.build(enquiry_params.merge(user: current_user))
        if enquiry.save
          render json: serialize_enquiry(enquiry), status: :created
        else
          render json: { errors: enquiry.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        authorize_owner!
        render json: @listing.enquiries.map { |enq| serialize_enquiry(enq) }
      end

      def my_enquiries
        render json: current_user.enquiries.map { |enq| serialize_enquiry(enq) }
      end

      private
      def set_listing
        @listing = Listing.find(params[:listing_id])
      end

      def enquiry_params
        params.require(:enquiry).permit(:message)
      end

      def serialize_enquiry(enquiry)
        {
          id: enquiry.id,
          message: enquiry.message,
          listing_id: enquiry.listing_id,
          sender: {
            id: enquiry.user.id,
            username: enquiry.user.username,
            email: enquiry.user.email
          },
          created_at: enquiry.created_at
        }
      end

      def authorize_owner!
        raise Pundit::NotAuthorizedError unless @listing.user_id == current_user.id
      end
    end
  end
end
