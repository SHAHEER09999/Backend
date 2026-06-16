class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.references :brand, null: false, foreign_key: { to_table: :users }
      t.references :influencer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :conversations,
              [:brand_id, :influencer_id],
              unique: true
  end
end