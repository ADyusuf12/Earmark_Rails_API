module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_enquiry

      # GET /api/v1/listings/:listing_id/enquiries/:enquiry_id/messages
      def index
        authorize @enquiry, :show?   # EnquiryPolicy governs visibility
        render json: @enquiry.messages.order(created_at: :desc).map { |msg| serialize_message(msg) }
      end

      # POST /api/v1/listings/:listing_id/enquiries/:enquiry_id/messages
      def create
        message = @enquiry.messages.build(
          body: params[:body],
          sender: current_user
        )
        authorize message   # MessagePolicy governs who can post

        if message.save
          render json: serialize_message(message), status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_enquiry
        @enquiry = Enquiry.find(params[:enquiry_id])
      end

      def serialize_message(message)
        {
          id: message.id,
          body: message.body,
          sender: {
            id: message.sender.id,
            username: message.sender.username,
            email: message.sender.email
          },
          created_at: message.created_at
        }
      end
    end
  end
end
