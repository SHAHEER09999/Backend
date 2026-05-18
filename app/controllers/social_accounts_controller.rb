class SocialAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile
  before_action :set_social_account, only: %i[ show update destroy ]

  # GET /profiles/:profile_id/social_accounts
  def index
    @social_accounts = @profile.social_accounts
    render json: @social_accounts
  end

  # GET /profiles/:profile_id/social_accounts/:id
  def show
    render json: @social_account
  end

  # 🛠️ ADD THIS METHOD: POST /profiles/:profile_id/social_accounts
  def create
    return render json: { error: "Only influencers can add social accounts" }, status: :forbidden unless current_user.influencer?

    # Build the record off the scoped profile resource parameters
    @social_account = @profile.social_accounts.new(social_account_params)

    if @social_account.save
      render json: @social_account, status: :created
    else
      render json: { errors: @social_account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /social_accounts/verify_and_create
  def verify_and_create
    return render json: { error: "Only influencers can add social accounts" }, status: :forbidden unless current_user.influencer?

    profile = current_user.profile
    return render json: { error: "Profile not found" }, status: :not_found unless profile

    platform = params[:platform]
    username = params[:username]

    unless platform == "youtube"
      return render json: { error: "Only YouTube is supported currently" }, status: :unprocessable_entity
    end

    result = YoutubeService.verify(username)

    unless result[:success]
      return render json: { error: result[:error] }, status: :unprocessable_entity
    end

    social_account = profile.social_accounts.find_or_initialize_by(platform: :youtube)
    social_account.username = result[:username]
    social_account.followers = result[:followers]
    social_account.save!

    render json: {
      message: "YouTube account verified successfully",
      social_account: {
        id: social_account.id,
        platform: social_account.platform,
        username: social_account.username,
        followers: social_account.followers,
        title: result[:title]
      }
    }, status: :ok
  end

  # PATCH/PUT /profiles/:profile_id/social_accounts/:id
  def update
    if @social_account.update(social_account_params)
      render json: @social_account
    else
      render json: { errors: @social_account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/:profile_id/social_accounts/:id
  def destroy
    @social_account.destroy!
    render json: { message: "Social account removed successfully" }, status: :ok
  end

  private

    # Scopes the action safely to the profile parameter present in the request route
    def set_profile
      @profile = current_user.profile
      if params[:profile_id] && @profile.id != params[:profile_id].to_i
        render json: { error: "Unauthorized profile context" }, status: :unauthorized
      end
    end

    def set_social_account
      @social_account = @profile.social_accounts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Social account not found" }, status: :not_found
    end

    # Sanitization layer for params parsing
    def social_account_params
      params.require(:social_account).permit(
        :platform,
        :username,
        :followers
      )
    end
end