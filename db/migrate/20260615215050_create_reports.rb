class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.references :reporter_profile, null: false, foreign_key: { to_table: :profiles }
      t.references :reported_profile, null: false, foreign_key: { to_table: :profiles }

      t.text :description

      t.timestamps
    end
  end
end