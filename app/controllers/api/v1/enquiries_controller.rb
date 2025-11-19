module Api
  module V1
    class EnquiriesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_listing, only: [ :create, :index ]

      # POST /api/v1/listings/:listing_id/enquiries
      def create
        authorize Enquiry, :create?

        enquiry = @listing.enquiries.build(user: current_user, message: enquiry_params[:message])

        if enquiry.save
          enquiry.messages.create!(
            body: enquiry.message,
            sender: current_user
          )

          render json: serialize_enquiry(enquiry), status: :created
        else
          render json: { errors: enquiry.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/listings/:listing_id/enquiries
      def index
        authorize @listing, :show_enquiries?

        enquiries = @listing.enquiries
        render json: enquiries.map { |enq| serialize_enquiry(enq) }
      end

      # GET /api/v1/enquiries
      def my_enquiries
        enquiries = current_user.enquiries
        # each enquiry still authorized individually if you want strictness:
        # enquiries.each { |enq| authorize enq, :show? }
        render json: enquiries.map { |enq| serialize_enquiry(enq) }
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
          listing_id: enquiry.listing_id,
          sender: {
            id: enquiry.user.id,
            username: enquiry.user.username,
            email: enquiry.user.email
          },
          created_at: enquiry.created_at,
          messages: enquiry.messages.order(created_at: :asc).map do |msg|
            {
              id: msg.id,
              body: msg.body,
              sender_id: msg.sender_id,
              created_at: msg.created_at
            }
          end
        }
      end
    end
  end
end
