class Profile < ApplicationRecord
  has_many :social_accounts, dependent: :destroy
  belongs_to :user
  has_many :categories, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_one_attached :image
  validates :user_id, uniqueness: true
  has_many :meeting_responses, dependent: :destroy

  has_many :campaigns, dependent: :destroy
  has_many :campaign_applications, dependent: :destroy
  has_many :applied_campaigns,
           through: :campaign_applications,
           source: :campaign
end
