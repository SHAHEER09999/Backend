class Feedback < ApplicationRecord
  belongs_to :profile

  belongs_to :brand_profile,
             class_name: "Profile"

  validates :comment, presence: true

  validates :rating,
            presence: true,
            inclusion: { in: 1..5 }

  validates :brand_profile_id,
            uniqueness: {
              scope: :profile_id,
              message: "has already submitted feedback for this influencer"
            }
end