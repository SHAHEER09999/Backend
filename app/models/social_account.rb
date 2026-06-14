class SocialAccount < ApplicationRecord
  belongs_to :profile

  enum :platform, [ :instagram, :tiktok, :youtube ]
  validates :price,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true
  
  validates :username, presence: true
  validates :platform, presence: true
  validates :followers, presence: true
end
