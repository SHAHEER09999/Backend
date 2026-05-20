class CampaignApplication < ApplicationRecord
  belongs_to :campaign
  belongs_to :profile

  enum :status, {
    pending: 0,
    accepted: 1,
    rejected: 2
  }

  validates :profile_id,
            uniqueness: {
              scope: :campaign_id,
              message: "has already applied to this campaign"
            }
end