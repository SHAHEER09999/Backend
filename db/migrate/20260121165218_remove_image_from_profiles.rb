class RemoveImageFromProfiles < ActiveRecord::Migration[8.1]
  def change
    remove_column :profiles, :image, :string
  end
end
