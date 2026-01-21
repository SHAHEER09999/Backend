class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.integer :categories
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
