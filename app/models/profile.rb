class Profile < ApplicationRecord
  has_many :social_accounts, dependent: :destroy
end
