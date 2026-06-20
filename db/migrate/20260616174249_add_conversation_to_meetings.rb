class AddConversationToMeetings < ActiveRecord::Migration[8.1]
  def change
    add_reference :meetings, :conversation, foreign_key: true
  end
end