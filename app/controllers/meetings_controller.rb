class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.brand? 
      campaign_ids = current_user.profile.campaigns.pluck(:id)
      campaign_meetings = Meeting.where(campaign_id: campaign_ids) 
      chat_meetings = Meeting.where(conversation_id: Conversation.where(brand_id: current_user.id))
      @meetings = (campaign_meetings + chat_meetings).uniq
    else
      applied_campaign_ids = CampaignApplication.where(profile_id: current_user.profile.id).pluck(:campaign_id)
      campaign_meetings = Meeting.where(campaign_id: applied_campaign_ids)
      chat_meetings = Meeting.where(conversation_id: Conversation.where(influencer_id: current_user.id))
      @meetings = (campaign_meetings + chat_meetings).uniq
    end

    # Explicitly include nested relationships for the frontend
    render json: @meetings.as_json(
      include: {
        campaign: { only: [:id, :name] },
        conversation: { 
          include: { 
            brand: { include: :profile },
            influencer: { include: :profile }
          } 
        },
        meeting_responses: {
          include: { profile: { only: [:id, :name] } }
        }
      }
    )
  end

  # GET /meetings/chat_brands
  def chat_brands
    conversations = Conversation.where(influencer_id: current_user.id).includes(brand: :profile)

    render json: conversations.map { |c|
      {
        conversation_id: c.id,
        brand_id: c.brand_id,
        brand_name: c.brand.profile&.name || "Unknown Brand"
      }
    }
  end

  # POST /meetings/create_chat_meeting
  def create_chat_meeting
    conversation = Conversation.find(params[:conversation_id])

    unless conversation.influencer_id == current_user.id
      return render json: { error: "Only the assigned influencer can create a meeting for this chat" }, status: :unauthorized
    end

    meeting = Meeting.new(
      conversation: conversation,
      meeting_type: params[:meeting_type],
      date_time: params[:date_time],
      location_link: params[:location_link],
      notes: params[:notes]
    )

    if meeting.save
      render json: meeting, status: :created
    else
      render json: { errors: meeting.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    profile = current_user.profile
    campaign = profile.campaigns.find_by(id: params[:meeting][:campaign_id])
    
    unless campaign
      return render json: { error: "Campaign not found or unauthorized" }, status: :unauthorized
    end

    meeting = campaign.meetings.new(meeting_params)
    if meeting.save
      render json: meeting, status: :created
    else
      render json: { errors: meeting.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    meeting = Meeting.find(params[:id])
    
    if meeting.campaign && meeting.campaign.profile_id == current_user.profile.id
      meeting.destroy
      render json: { message: "Meeting deleted successfully" }
    elsif meeting.conversation && (meeting.conversation.brand_id == current_user.id || meeting.conversation.influencer_id == current_user.id)
      meeting.destroy
      render json: { message: "Meeting deleted successfully" }
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def meeting_params
    params.require(:meeting).permit(:campaign_id, :meeting_type, :date_time, :location_link, :notes)
  end
end