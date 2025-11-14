class Enquiry < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates :message, presence: true, length: { minimum: 10 }
end
