class Enquiry < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  has_many :messages, dependent: :destroy

  validates :message, presence: true, length: { minimum: 10 }
end
