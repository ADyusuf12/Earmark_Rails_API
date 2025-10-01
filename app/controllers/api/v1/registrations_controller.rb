module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      def create
        build_resource(sign_up_params)

        if resource.save
           token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

          render json: {
            access: token,
            user: {
              id: resource.id,
              username: resource.username,
              email: resource.email
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
        params.require(:user).permit(:email, :password, :password_confirmation, :username)
      end
    end
  end
end
