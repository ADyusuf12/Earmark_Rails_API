class OverviewPolicy < ApplicationPolicy
  def show?
    user&.admin? || user.property_owner? || user.agent? || user.property_developer?
  end
end
