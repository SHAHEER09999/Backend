class AddPriceToSocialAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :social_accounts, :price, :decimal
  end
end
