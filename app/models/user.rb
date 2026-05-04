class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_one :profile, dependent: :destroy

  enum :role, [ :admin, :brand, :influencer ]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: self




  def after_confirmation
    super  # ✅ VERY IMPORTANT

    create_profile_after_confirmation
  end
  # For account deletion
  def generate_delete_token
    self.delete_token = SecureRandom.urlsafe_base64
    self.delete_sent_at = Time.current
    save!
  end

  def delete_token_valid?(token)
    return false if delete_token != token
    return false if delete_sent_at < 15.minutes.ago
    true
  end

  def create_profile_after_confirmation
    return if admin?
    return if profile.present?

    create_profile!(
      name: email.split("@").first
    )
  end
end


