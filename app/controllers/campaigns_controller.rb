class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:create]
  before_action :set_campaign, only: [:show, :update, :destroy]

  # GET /campaigns
  # Influencers use this endpoint to see all campaigns
  def index
    if params[:profile_id].present?
      # Brand: show only campaigns created by this profile
      profile = Profile.find(params[:profile_id])

      campaigns = profile.campaigns.includes(
        campaign_applications: :profile
      )

      render json: campaigns.as_json(
        include: {
          campaign_applications: {
            include: {
              profile: {
                only: [:id, :name]
              }
            }
          }
        }
      )
    else
      # Influencer: show all campaigns
      campaigns = Campaign.includes(:profile)

      render json: campaigns.as_json(
        include: {
          profile: {
            only: [:id, :name]
          }
        }
      )
    end
  end

  # GET /campaigns/:id
  def show
    render json: @campaign.as_json(
      include: {
        campaign_applications: {
          include: {
            profile: {
              only: [:id, :name, :description]
            }
          }
        }
      }
    )
  end

  # POST /profiles/:profile_id/campaigns
  def create
    campaign = @profile.campaigns.new(campaign_params)

    if campaign.save
      render json: campaign, status: :created
    else
      render json: {
        errors: campaign.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /campaigns/:id
  def update
    if @campaign.update(campaign_params)
      render json: @campaign
    else
      render json: {
        errors: @campaign.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /campaigns/:id
  def destroy
    @campaign.destroy
    render json: {
      message: "Campaign deleted successfully"
    }
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(
      :name,
      :platform,
      :budget,
      :description
    )
  end
end