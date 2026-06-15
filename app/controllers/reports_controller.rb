class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    unless current_user.brand?
      return render json: {
        error: "Only brands can report influencers"
      }, status: :forbidden
    end
    reported_profile = Profile.find(params[:profile_id])

    report = Report.new(
      reporter_profile: current_user.profile,
      reported_profile: reported_profile,
      description: params[:description]
    )

    # attach images
    if params[:images].present?
      params[:images].each do |img|
        report.proof_images.attach(img)
      end
    end

    if report.save
      render json: { message: "Report submitted successfully" }, status: :created
    else
      render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
    end
  end
end