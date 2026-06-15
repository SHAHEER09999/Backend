class Report < ApplicationRecord
  belongs_to :reporter_profile, class_name: "Profile"
  belongs_to :reported_profile, class_name: "Profile"

  has_many_attached :proof_images

  validates :description, presence: true
end