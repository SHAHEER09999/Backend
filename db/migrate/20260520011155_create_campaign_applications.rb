class CreateCampaignApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_applications do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :campaign_applications,
              [:campaign_id, :profile_id], unique: true
  end
end