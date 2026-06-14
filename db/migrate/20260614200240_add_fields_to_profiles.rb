class AddFieldsToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :gender, :integer
    add_column :profiles, :age, :integer
    add_column :profiles, :delivery_time, :string
    add_column :profiles, :language, :string
  end
end
