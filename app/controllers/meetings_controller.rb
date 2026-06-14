class MeetingsController < ApplicationController
  before_action :authenticate_user!

  def index
    profile = current_user.profile
    
    if current_user.role.downcase == 'brand'
      # Brands see meetings for their campaigns and ALL responses
      campaigns = profile.campaigns
      meetings = Meeting.where(campaign_id: campaigns.select(:id))
                        .includes(:campaign, meeting_responses: :profile)
                        .order(created_at: :desc)

      render json: meetings.as_json(
        include: {
          campaign: { only: [:id, :name] },
          meeting_responses: {
            include: { profile: { only: [:id, :name] } }
          }
        }
      )
    else
      # Influencers see meetings ONLY for campaigns they applied to
      applied_campaign_ids = profile.campaign_applications.select(:campaign_id)
      meetings = Meeting.where(campaign_id: applied_campaign_ids)
                        .includes(:campaign, :meeting_responses)
                        .order(created_at: :desc)

      # Send the meetings, but only attach the CURRENT influencer's response if they made one
      render json: meetings.map { |meeting|
        meeting_data = meeting.as_json(include: { campaign: { only: [:id, :name] } })
        meeting_data[:my_response] = meeting.meeting_responses.find { |r| r.profile_id == profile.id }
        meeting_data
      }
    end
  end

  def create
    profile = current_user.profile
    # Ensure the brand owns the campaign they are creating a meeting for
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
    
    # Ensure only the brand who owns the campaign can delete it
    if meeting.campaign.profile_id == current_user.profile.id
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