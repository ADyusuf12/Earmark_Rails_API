class MessagePolicy < ApplicationPolicy
  def index?
    participant?
  end

  def create?
    participant?
  end

  private

  def participant?
    record.enquiry.user_id == user.id || record.enquiry.listing.user_id == user.id
  end
end
