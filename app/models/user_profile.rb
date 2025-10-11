# app/models/user_profile.rb
class UserProfile < ApplicationRecord
  ACCOUNT_TYPES = %w[agent developer owner customer].freeze

  belongs_to :user
  has_one_attached :profile_picture

  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }
  validates :first_name, length: { maximum: 50 }, allow_blank: true
  validates :last_name, length: { maximum: 50 }, allow_blank: true
  validates :phone_number, length: { maximum: 16 }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true
end
