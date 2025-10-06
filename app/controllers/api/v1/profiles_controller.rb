class Api::V1::ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: serialize_profile(current_user)
  end

  def update
    profile = current_user.user_profile
    if profile.nil?
      render json: { errors: [ "Profile not found" ] }, status: :not_found
      return
    end

    if profile.update(profile_params)
      render json: serialize_profile(current_user)
    else
      render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:account_type, :first_name, :last_name)
  end

  def serialize_profile(user)
    profile = user.user_profile
    {
      user: {
        id: user.id,
        email: user.email,
        username: user.username
      },
      profile: profile ? {
        id: profile.id,
        account_type: profile.account_type,
        first_name: profile.first_name,
        last_name: profile.last_name
      } : nil
    }
  end
end
