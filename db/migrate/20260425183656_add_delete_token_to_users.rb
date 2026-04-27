class AddDeleteTokenToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :delete_token, :string
    add_column :users, :delete_sent_at, :datetime
  end
end
