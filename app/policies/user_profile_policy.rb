class UserProfilePolicy < ApplicationPolicy
  def show?
    user.present?
  end

  def update?
    admin? || record.user == user
  end

  private
  def admin?
    user&.admin?
  end
end
