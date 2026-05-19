class CreateBankAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :bank_accounts do |t|
      t.string :account_name
      t.string :account_number
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
