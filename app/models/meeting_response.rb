class MeetingResponse < ApplicationRecord
  belongs_to :meeting
  belongs_to :profile

  enum :status, { pending: 0, accepted: 1, denied: 2 }

  validates :status, presence: true
  validates :reason, presence: true, if: -> { denied? }
end