class Listing < ApplicationRecord
  belongs_to :user

  has_many_attached :images

  validates :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true
  validates :description, presence: true, length: { maximum: 500 }
end
