class Conversation < ApplicationRecord
  belongs_to :brand, class_name: "User"
  belongs_to :influencer, class_name: "User"

  has_many :messages, dependent: :destroy
end