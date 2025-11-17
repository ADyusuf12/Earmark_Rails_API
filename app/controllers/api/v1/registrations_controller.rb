module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      def create
        account_type = sign_up_params[:account_type].presence

        # validate against the enum keys on User
        unless User.account_types.keys.include?(account_type)
          return render json: {
            status: { code: 422, message: "Invalid account_type" },
            errors: [ "account_type must be one of: #{User.account_types.keys.join(', ')}" ]
          }, status: :unprocessable_entity
        end

        # build user with account_type directly
        build_resource(sign_up_params)

        if resource.save
          token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

          render json: {
            access: token,
            user: {
              id: resource.id,
              username: resource.username,
              email: resource.email,
              account_type: resource.account_type
            },
            profile: {
              id: resource.user_profile.id,
              first_name: resource.user_profile.first_name,
              last_name: resource.user_profile.last_name,
              phone_number: resource.user_profile.phone_number,
              bio: resource.user_profile.bio,
              profile_picture_url: resource.user_profile.profile_picture.attached? ?
                Rails.application.routes.url_helpers.rails_blob_url(resource.user_profile.profile_picture, only_path: true) : nil
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
