class Message < ApplicationRecord
  belongs_to :enquiry
  belongs_to :sender, class_name: "User"

  validates :body, presence: true
end
