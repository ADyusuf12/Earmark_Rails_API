class Api::V1::UserProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    profile =
      if params[:id]
        User.find(params[:id]).user_profile
      else
        current_user.user_profile
      end
    authorize profile
    render json: serialize_profile(profile.user), status: :ok
  end

  def update
    profile =
      if params[:id]
        User.find(params[:id]).user_profile
      else
        current_user.user_profile
      end
    return render json: { errors: [ "Profile not found" ] }, status: :not_found unless profile

    authorize profile

    if profile.update(profile_params)
      render json: serialize_profile(profile.user), status: :ok
    else
      render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(:account_type, :first_name, :last_name, :phone_number, :bio, :profile_picture)
  end

  def serialize_profile(user)
    profile = user.user_profile
    {
      user: {
        id: user.id,
        email: user.email,
        username: user.username
      },
      profile: profile && {
        id: profile.id,
        account_type: profile.account_type,
        first_name: profile.first_name,
        last_name: profile.last_name,
        phone_number: profile.phone_number,
        bio: profile.bio,
        profile_picture_url: profile.profile_picture.attached? ? url_for(profile.profile_picture) : nil
      }
    }
  end
end
