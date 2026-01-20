class Profile < ApplicationRecord
  has_many :social_accounts, dependent: :destroy
  belongs_to :user
end
