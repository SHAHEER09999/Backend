class CampaignApplicationsController < ApplicationController
  before_action :authenticate_user!

  # POST /campaigns/:campaign_id/campaign_applications
  def create
    campaign = Campaign.find(params[:campaign_id])
    profile = current_user.profile

    application = campaign.campaign_applications.new(profile: profile)

    if application.save
      render json: application, status: :created
    else
      render json: { errors: application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /campaigns/:campaign_id/campaign_applications/:id
  def destroy
    application = CampaignApplication.find(params[:id])
    application.destroy

    render json: { message: 'Application withdrawn successfully' }
  end
end
