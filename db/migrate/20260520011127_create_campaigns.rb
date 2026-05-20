class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :platform
      t.decimal :budget, precision: 10, scale: 2
      t.text :description
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
