class Profile < ApplicationRecord
  has_many :social_accounts, dependent: :destroy
  belongs_to :user
  has_many :categories, dependent: :destroy

  has_one_attached :image
end
