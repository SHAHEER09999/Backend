class CreateMeetingResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :meeting_responses do |t|
      t.references :meeting, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.integer :status
      t.text :reason

      t.timestamps
    end
  end
end
