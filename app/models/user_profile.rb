class UserProfile < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture

  validates :first_name, length: { maximum: 50 }, allow_blank: true
  validates :last_name, length: { maximum: 50 }, allow_blank: true
  validates :phone_number, length: { maximum: 16 }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true

  def as_json(options = {})
    {
      id: id,
      first_name: first_name,
      last_name: last_name,
      phone_number: phone_number,
      bio: bio,
      profile_picture_url: profile_picture.attached? ? Rails.application.routes.url_helpers.rails_blob_url(profile_picture, only_path: true) : nil
    }
  end
end
