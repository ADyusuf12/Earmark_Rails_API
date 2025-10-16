module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      def create
        account_type = sign_up_params[:account_type].presence

        unless UserProfile::ACCOUNT_TYPES.include?(account_type)
          return render json: {
            status: { code: 422, message: "Invalid account_type" },
            errors: [ "account_type must be one of: #{UserProfile::ACCOUNT_TYPES.join(', ')}" ]
          }, status: :unprocessable_entity
        end

        build_resource(sign_up_params.except(:account_type))
        resource.account_type = account_type

        if resource.save
          token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

          render json: {
            access: token,
            user: {
              id: resource.id,
              username: resource.username,
              email: resource.email
            },
            profile: {
              id: resource.user_profile.id,
              account_type: resource.user_profile.account_type
            }
          }, status: :ok
        else
          render json: {
            status: { code: 422, message: "User could not be created" },
            errors: resource.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username, :account_type)
      end
    end
  end
end
