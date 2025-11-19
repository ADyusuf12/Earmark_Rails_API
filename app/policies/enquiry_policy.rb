class EnquiryPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def show?
    # either the enquirer or the listing owner can view
    record.user_id == user.id || record.listing.user_id == user.id
  end
end
