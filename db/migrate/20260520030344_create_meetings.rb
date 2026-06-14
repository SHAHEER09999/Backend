class CreateMeetings < ActiveRecord::Migration[8.1]
  def change
    create_table :meetings do |t|
      t.references :campaign, null: false, foreign_key: true
      t.integer :meeting_type
      t.datetime :date_time
      t.string :location_link
      t.text :notes

      t.timestamps
    end
  end
end
