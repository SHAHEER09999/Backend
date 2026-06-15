class CreateFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feedbacks do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :brand_profile, null: false, foreign_key: { to_table: :profiles }

      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end