class CreateSocialAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :social_accounts do |t|
      t.integer :platform
      t.string :username, null: false
      t.string :followers, null: false
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
