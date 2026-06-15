class Profile < ApplicationRecord
  has_many :social_accounts, dependent: :destroy
  belongs_to :user
  has_many :categories, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_one_attached :image

  validates :user_id, uniqueness: true

  has_many :meeting_responses, dependent: :destroy

  enum :gender, {
    male: 0,
    female: 1,
    other: 2
  }

  has_many :sent_reports,
          class_name: "Report",
          foreign_key: :reporter_profile_id,
          dependent: :destroy

  has_many :received_reports,
          class_name: "Report",
          foreign_key: :reported_profile_id,
          dependent: :destroy

  has_many :received_feedbacks,
           class_name: "Feedback",
           dependent: :destroy

  has_many :given_feedbacks,
           class_name: "Feedback",
           foreign_key: :brand_profile_id,
           dependent: :destroy

  has_many :campaigns, dependent: :destroy
  has_many :campaign_applications, dependent: :destroy
  has_many :applied_campaigns,
           through: :campaign_applications,
           source: :campaign

  # ✅ STEP 12 ADDED HERE
  def average_rating
    received_feedbacks.average(:rating)&.round(1) || 0
  end

  def total_feedbacks
    received_feedbacks.count
  end
end