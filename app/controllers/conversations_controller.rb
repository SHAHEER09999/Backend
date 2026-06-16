class ConversationsController < ApplicationController
  before_action :authenticate_user!

  # app/controllers/conversations_controller.rb
  def index
    conversations = Conversation.where("brand_id = ? OR influencer_id = ?", current_user.id, current_user.id).includes(:brand, :influencer, :messages)

    # Map over results to structure clean keys for React to consume
    formatted_conversations = conversations.map do |conv|
      # Determine who the other participant is relative to current_user
      other_user = conv.brand_id == current_user.id ? conv.influencer : conv.brand
      
      # Safely retrieve their linked Profile name
      recipient_name = other_user&.profile&.name || other_user&.email || "User ##{other_user&.id}"

      {
        id: conv.id,
        updated_at: conv.updated_at,
        recipient_name: recipient_name,
        last_message: conv.messages.last&.content
      }
    end

    render json: formatted_conversations
  end

  def create
    influencer_id = params[:influencer_id]

    # Find the existing conversation or prepare a new one
    conversation = Conversation.find_or_initialize_by(
      brand_id: current_user.id,
      influencer_id: influencer_id
    )

    # If it's already in the DB, or saves successfully, return it
    if conversation.persisted? || conversation.save
      render json: conversation
    else
      # This will expose exactly which validation is failing (e.g., missing fields, custom rules)
      render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    conversation = Conversation.find(params[:id])

    render json: conversation,
           include: :messages
  end
end