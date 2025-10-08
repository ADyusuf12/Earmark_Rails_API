class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one :user_profile, dependent: :destroy
  has_many :listings, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  after_create :create_default_profile

  private

  def create_default_profile
    create_user_profile!(account_type: "customer")
  end
end
