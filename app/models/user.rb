class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  attr_accessor :account_type

  has_one :user_profile, dependent: :destroy
  has_many :listings, dependent: :destroy
  has_many :saved_listings, dependent: :destroy
  has_many :saved_listed_listings, through: :saved_listings, source: :listing

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  after_create :create_profile_with_account_type

  private

  def create_profile_with_account_type
    create_user_profile!(account_type: account_type)
  end
end
