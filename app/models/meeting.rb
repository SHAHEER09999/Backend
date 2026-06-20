class Meeting < ApplicationRecord
  # Make both relationships optional so a meeting can be either a Chat Meeting or a Campaign Meeting
  belongs_to :campaign, optional: true
  belongs_to :conversation, optional: true

  has_many :meeting_responses, dependent: :destroy

  enum :meeting_type, {
    online: 0,
    physical: 1
  }

  validates :date_time, presence: true
  validates :location_link, presence: true
  validates :notes, presence: true
end