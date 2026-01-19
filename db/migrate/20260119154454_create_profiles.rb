class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :image
      t.text :description
      t.string :location_website

      t.timestamps
    end
  end
end
