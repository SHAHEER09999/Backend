class MeetingResponsesController < ApplicationController
  before_action :authenticate_user!

  def respond
    meeting = Meeting.find(params[:meeting_id])
    profile = current_user.profile

    # Verify influencer actually applied to the campaign this meeting belongs to
    unless profile.campaign_applications.exists?(campaign_id: meeting.campaign_id)
      return render json: { error: "You must apply to the campaign to respond to this meeting." }, status: :unauthorized
    end

    response = meeting.meeting_responses.find_or_initialize_by(profile: profile)
    response.status = params[:status]
    response.reason = params[:status] == 'denied' ? params[:reason] : nil

    if response.save
      render json: response
    else
      render json: { errors: response.errors.full_messages }, status: :unprocessable_entity
    end
  end
end