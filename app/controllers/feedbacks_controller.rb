class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def index
    profile = Profile.find(params[:profile_id])

    feedbacks =
      profile.received_feedbacks
            .includes(:brand_profile)
            .order(created_at: :desc)
            .limit(5)

    render json: feedbacks.as_json(
      include: {
        brand_profile: {
          only: [:id, :name]
        }
      }
    )
  end
  

  def create
    profile = Profile.find(params[:profile_id])

    unless current_user.brand?
      return render json: {
        error: "Only brands can submit feedback"
      }, status: :forbidden
    end

    feedback = profile.received_feedbacks.new(
      feedback_params.merge(
        brand_profile: current_user.profile
      )
    )

    if feedback.save
      render json: feedback, status: :created
    else
      render json: {
        errors: feedback.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback)
          .permit(:rating, :comment)
  end
end