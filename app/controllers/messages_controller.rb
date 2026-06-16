class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    conversation =
      Conversation.find(params[:conversation_id])

    render json: conversation.messages
  end

  def create
    conversation =
      Conversation.find(params[:conversation_id])

    message =
      conversation.messages.create!(
        sender: current_user,
        content: params[:content]
      )

    render json: message
  end
end