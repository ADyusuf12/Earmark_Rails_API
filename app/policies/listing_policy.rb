class ListingPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin? || user_has_role?(:property_owner, :agent, :property_developer)
  end

  def update?
    admin? || (user_owns_listing? && user_has_role?(:property_owner, :agent, :property_developer))
  end

  def destroy?
    admin? || (user_owns_listing? && user_has_role?(:property_owner, :agent, :property_developer))
  end

  private

  def admin?
    user.admin?
  end

  def user_owns_listing?
    record.user == user
  end

  def user_has_role?(*roles)
    roles.include?(user.account_type.to_sym)
  end
end
