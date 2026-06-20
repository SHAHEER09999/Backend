class ChangeCampaignIdNullOnMeetings < ActiveRecord::Migration[8.0] # or your current version
  def change
    # table_name, column_name, null_allowed
    change_column_null :meetings, :campaign_id, true
  end
end