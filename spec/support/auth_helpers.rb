# spec/support/auth_helpers.rb
module AuthHelpers
  # Generate a JWT for a given user using Devise::JWT
  def jwt_token_for(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end

  # Convenience method: login by user id (or user object)
  def user_login(user_or_id)
    user = user_or_id.is_a?(User) ? user_or_id : User.find(user_or_id)
    token = jwt_token_for(user)
    "Bearer #{token}"
  end
end
