class CreateAdminUserManagements < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_user_managements do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
