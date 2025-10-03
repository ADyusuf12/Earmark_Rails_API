# app/models/user_profile.rb
class UserProfile < ApplicationRecord
  ACCOUNT_TYPES = %w[agent developer owner customer].freeze

  belongs_to :user

  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }
end
