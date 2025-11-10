class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { errors: [ "Not authorized" ] }, status: :forbidden
  end
end
