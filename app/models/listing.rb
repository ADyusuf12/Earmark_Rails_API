class Listing < ApplicationRecord
  belongs_to :user

  has_many_attached :images
  has_many :saved_listings, dependent: :destroy
  has_many :saved_by_users, through: :saved_listings, source: :user
  has_many :enquiries, dependent: :destroy

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true
  validates :description, presence: true, length: { maximum: 500 }
end
