class Meeting < ApplicationRecord
  belongs_to :campaign
  has_many :meeting_responses, dependent: :destroy

  enum :meeting_type, { online: 0, physical: 1 }

  validates :date_time, presence: true
  validates :location_link, presence: true
  validates :notes, presence: true
end