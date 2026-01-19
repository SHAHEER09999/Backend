class SocialAccount < ApplicationRecord
  belongs_to :profile

  enum :platform, [ :instagram, :tiktok, :youtube ]
  
  validates :username, presence: true
  validates :platform, presence: true
  validates :followers, presence: true
end
