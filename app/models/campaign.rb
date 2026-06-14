class Campaign < ApplicationRecord
  belongs_to :profile
  
  has_many :meetings, dependent: :destroy
  has_many :campaign_applications, dependent: :destroy
  has_many :applicants,
           through: :campaign_applications,
           source: :profile

  enum :platform, {
    instagram: 0,
    youtube: 1,
    tiktok: 2
  }

  validates :name, presence: true
  validates :budget, presence: true
  validates :description, presence: true
end
