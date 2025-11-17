class OverviewPolicy < ApplicationPolicy
  def show?
    user&.admin? || user_has_role?(:property_owner, :agent, :property_developer)
  end

  private

  def user_has_role?(*roles)
    roles.include?(user.account_type.to_sym)
  end
end
