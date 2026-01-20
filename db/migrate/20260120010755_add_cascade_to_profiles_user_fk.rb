class AddCascadeToProfilesUserFk < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :profiles, :users
    add_foreign_key :profiles, :users, on_delete: :cascade
  end
end
