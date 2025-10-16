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

  # Role check helper for Pundit and controllers
  def role?(type)
    account_type == type.to_s
  end

  # Scope for filtering by role
  scope :with_role, ->(role) { where(account_type: role.to_s) }

  # Serializer for consistent JSON output
  def as_json(options = {})
    {
      id: id,
      account_type: account_type,
      first_name: first_name,
      last_name: last_name,
      phone_number: phone_number,
      bio: bio,
      profile_picture_url: profile_picture.attached? ? Rails.application.routes.url_helpers.rails_blob_url(profile_picture, only_path: true) : nil
    }
  end
end
