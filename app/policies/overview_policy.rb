class OverviewPolicy < ApplicationPolicy
  def show?
    user&.admin? || user_has_role?(:owner, :agent, :developer)
  end

  private

  def user_has_role?(*roles)
    roles.include?(user.user_profile&.account_type&.to_sym)
  end
end
