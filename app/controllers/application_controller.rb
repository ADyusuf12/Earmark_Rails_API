class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Override Devise's behavior for API-only apps
  def authenticate_user!
    unless user_signed_in?
      render json: { errors: [ "You need to sign in or sign up before continuing." ] },
             status: :unauthorized
    else
      super
    end
  end

  private

  def user_not_authorized
    render json: { errors: [ "Not authorized" ] }, status: :forbidden
  end
end
