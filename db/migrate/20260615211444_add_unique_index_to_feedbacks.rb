class AddUniqueIndexToFeedbacks < ActiveRecord::Migration[8.1]
  def change
    add_index :feedbacks,
              [:profile_id, :brand_profile_id],
              unique: true
  end
end