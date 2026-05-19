class BankAccount < ApplicationRecord
  belongs_to :profile

  validates :account_name, presence: true
  validates :account_number, presence: true, uniqueness: true

  validate :limit_three_accounts_per_profile

  private

  def limit_three_accounts_per_profile
    if profile.bank_accounts.count >= 3 && new_record?
      errors.add(:base, "Maximum 3 bank accounts allowed")
    end
  end
end