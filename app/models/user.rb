class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  enum :account_type, {
    customer: 0,
    agent: 1,
    property_developer: 2,
    property_owner: 3
  }

  enum :role, { user: 0, admin: 1 }

  has_one :user_profile, dependent: :destroy
  has_many :listings, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :saved_listed_listings, through: :saved_listings, source: :listing
  has_many :enquiries, dependent: :destroy
  has_many :messages, foreign_key: :sender_id, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :account_type, presence: true

  after_create :create_user_profile

  private

  def create_user_profile
    build_user_profile.save!
  end
end
