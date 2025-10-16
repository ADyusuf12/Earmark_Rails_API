class SavedListingPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    admin? || record.user == user
  end

  private

  def admin?
    user&.admin?
  end
end
